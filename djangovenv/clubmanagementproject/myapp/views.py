from django.contrib import messages
from django.core.mail import send_mail
from django.db.models import Q
from django.http import HttpResponse, JsonResponse, HttpResponseRedirect
from django.shortcuts import render,redirect
from django.urls import reverse
from django.utils.crypto import get_random_string
from rest_framework.status import HTTP_200_OK, HTTP_404_NOT_FOUND
from rest_framework.views import APIView

from myapp.forms import *
from .models import *
from django.contrib.auth import get_user_model, authenticate, login, logout
from rest_framework import generics
from django.db import IntegrityError

from rest_framework import viewsets
from .serializers import *
from rest_framework.permissions import AllowAny

class ClubMemberViewSet(viewsets.ModelViewSet):
    queryset = clubmember.objects.all()
    serializer_class = clubmemberSerializer

# class AddclubmemberAPI(generics.ListCreateAPIView):
#     queryset = clubmember.objects.all()
#     serializer_class = clubmemberSerializer
#     authentication_classes = []
#     permission_classes = [AllowAny]


from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from .models import Userprofile, clubmember
from .serializers import UserSerializer, clubmemberSerializer

def generate_account_details(pk):
    accntnumber = ""
    key = ""
    ifsc = ""
    list_of_chars = "1234567890"
    accntnumber_length = 11
    key_length = 3

    for i in range(accntnumber_length):
        accntnumber += random.choice(list_of_chars)
    for i in range(key_length):
        key += random.choice(list_of_chars)

    ifsc = "SBTR000055"
    amt = "500000"

    account_details = {
        'account_number': accntnumber,
        'key': key,
        'IFSC': ifsc,
        'amount': amt,
        'member':pk,
    }
    print(account_details)
    return (account_details)
    # return JsonResponse(account_details)
from django.contrib.auth.hashers import make_password

class AddClubmemberAPI(generics.CreateAPIView):
    queryset = clubmember.objects.all()
    serializer_class = clubmemberSerializer3
    permission_classes = [AllowAny]

    def post(self, request, *args, **kwargs):
        # Extract user data
        user_data = {
            'username': request.data.get('username'),
            # 'password': request.data.get('password'),
            'password': make_password(request.data.get('password')),
            'user_type': request.data.get('user_type'),
        }

        # Serialize and validate user data
        user_serializer = UserSerializer(data=user_data)
        if user_serializer.is_valid():
            # Create user object
            user = user_serializer.save()
        else:
            return Response(user_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        print(request.data.get('photo'))
        # Extract club member data
        clubmember_data = {
            'name': request.data.get('name'),
            'address': request.data.get('address'),
            'email': request.data.get('email'),
            'phoneno': request.data.get('phoneno'),
            'date_of_birth': request.data.get('date_of_birth'),
            'gender': request.data.get('gender'),
            'photo': request.data.get('photo'),  # You may need to handle photo separately
            'date_of_join': request.data.get('date_of_join'),
            'member': user.id,
        }

        # Serialize and validate club member data
        clubmember_serializer = clubmemberSerializer3(data=clubmember_data)
        if clubmember_serializer.is_valid():
            # Create club member object
            clubmember=clubmember_serializer.save()
            clubaccount_data = generate_account_details(clubmember.id)
            member_accountserializer = memberaccountserializer(data=clubaccount_data)
            if member_accountserializer.is_valid():
                member_accountserializer.save()
                return Response(member_accountserializer.data, status=status.HTTP_201_CREATED)
            return Response(clubmember_serializer.data, status=status.HTTP_201_CREATED)
        else:
            # Rollback user creation if club member creation fails
            user.delete()
            return Response(clubmember_serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# def loadadminhome(request):
#     return render("loaladminhome","adminhome.html",name='')
def loadindex(request):
    listx = clubprofile.objects.first()
    return render(request,"admin_index.html",{'listx': listx})
def loadhomeview(request):
    return render(request,'adminhome.html')
def adminviewprofile(request):
    list1 = clubprofile.objects.first()
    if list1:
        return render(request, 'adminviewprofile.html', {'list': list1})
    else:
        return redirect('addclubprofile')



def addclubprofile(request):
    list1 = clubprofile.objects.first()
    print(list1)
    User = get_user_model()
    if list1:
        if request.method == 'POST':
            updated_form2 = ClubProfileForm(request.POST, request.FILES, instance=list1)
            #updated_form1 = AdminLogForm(request.POST, instance=list.user)
            #updated_form2 = ClubProfileForm(request.POST, request.FILES, instance=list1)
            #if updated_form1.is_valid() and updated_form2.is_valid():
            if updated_form2.is_valid():
                updated_form2.save()
                #updated_form1.save()

                #user = updated_form1.instance
                # Set the password for the user
                #user.set_password(updated_form1.cleaned_data['password1'])
                #.save()
                # Save club profile form data
                ##club_profile = updated_form2.save(commit=False)
                #club_profile.user = user  # Assign the created user
                ##club_profile.user_type = 'admin'
                ##club_profile.save()
                return redirect('adminviewprofile')
        else:
            print("form to update")

            #updated_form1 = AdminLogForm(instance=list1.user)
            updated_form2 = ClubProfileForm(instance = list1)

            return render(request, 'admineditprofile.html', {'form2': updated_form2})

    else:

        if request.method == "POST":
            print("okkkk1111")
            form1 = AdminLogForm(request.POST)
            form2 = ClubProfileForm(request.POST, request.FILES)
            if form1.is_valid():
                print("okkkk")
            if form1.is_valid() and form2.is_valid():
                print("ok anju")
                # Save admin login form data
                user = form1.save()
                # Set the password for the user
                user.set_password(form1.cleaned_data['password1'])
                user.save()
                # Save club profile form data
                club_profile = form2.save(commit=False)
                club_profile.user = user  # Assign the created user
                club_profile.user_type = 'admin'
                club_profile.save()
                # Redirect to a success page or wherever appropriate
                return redirect('adminviewprofile')  # Replace 'login' with your success URL name
        else:
            form1 = AdminLogForm()
            form2 = ClubProfileForm()

            return render(request, 'adminaddprofile.html', {'form1': form1, 'form2': form2})
    return redirect('login')


# def addclubprofile(request):
#     User = get_user_model()
#
#     if request.method == 'POST':
#         if request.user.is_authenticated:
#             list1 = clubprofile.objects.first()
#
#             if list1:
#                 updated_form2 = ClubProfileForm(request.POST, request.FILES, instance=list1)
#
#                 if updated_form2.is_valid():
#                     updated_form2.save()
#                     return redirect('adminviewprofile')
#             else:
#                 form1 = AdminLogForm(request.POST)
#                 form2 = ClubProfileForm(request.POST, request.FILES)
#
#                 if form1.is_valid() and form2.is_valid():
#                     user = form1.save()
#                     user.set_password(form1.cleaned_data['password1'])
#                     user.save()
#
#                     club_profile = form2.save(commit=False)
#                     club_profile.user = user
#                     club_profile.user_type = 'admin'
#                     club_profile.save()
#
#                     return redirect('adminviewprofile')
#
#         else:
#             # Handle case where user is not authenticated, possibly redirect to login page
#             return redirect('login')
#
#     else:
#         # Handle GET request
#         list1 = clubprofile.objects.first()
#
#         if list1:
#             updated_form2 = ClubProfileForm(instance=list1)
#             return render(request, 'admineditprofile.html', {'form2': updated_form2})
#         else:
#             form1 = AdminLogForm()
#             form2 = ClubProfileForm()
#             return render(request, 'adminaddprofile.html', {'form1': form1, 'form2': form2})
#
#     # Redirect to login page if none of the conditions are met
#     return redirect('login')
#
def login_view(request):
    list = clubprofile.objects.first()
    if request.method=='POST':
        form=Loginform(request.POST)
        if form.is_valid():
            uname=form.cleaned_data['username']
            passwd=form.cleaned_data['password']
            user=authenticate(request,username=uname,password=passwd)
            if user is not None:
                login(request,user)
                messages.success(request,'sucess')
                listx = clubprofile.objects.first()

                return render(request,'adminhome.html')
            else:
                form.add_error(None,'Invalid email or password')
    else:
        form=Loginform()
        return render(request,'login.html',{'form':form,'list':list})
    return render(request,'login.html',{'form':form,'list':list})

def addclubgallery(request):
    if request.method == "POST":
        forms = uploadgallaryform(request.POST, request.FILES)  # Include request.FILES for file uploads
        if forms.is_valid():
            forms.save()
            messages.success(request, 'Gallery added successfully.')
            return render(request, 'uploadgallary.html', {'form': forms})

        else:
            return render(request, 'uploadgallary.html', {'form': forms})

    else:
        forms = uploadgallaryform()
        return render(request, 'uploadgallary.html', {'form': forms})

def adminaddsportsitem(request):
    if request.method == 'POST':
        form = sportsitemform(request.POST)
        if form.is_valid():
            item_name=form.cleaned_data['item_name']
            if sportsitem.objects.filter(Q(item_name__iexact=item_name)).exists():
                messages.error(request,'sports item with this name already exist')
            else:
                form.save()
                messages.success(request, 'Item registered successfully.')
                form = sportsitemform()
        return render(request,'adminaddsportsitem.html',{'form':form})
    else:
        form=sportsitemform()
        return render(request,'adminaddsportsitem.html',{'form':form})
def adminaddbatch(request):
    if request.method == 'POST':
        forms = BatchForm(request.POST, request.FILES)
        print(request.POST['batchname'])
        print(request.POST['batch_type'])
        if forms.is_valid():

            batch_name = forms.cleaned_data['batchname']
            batch_type=forms.cleaned_data['batch_type']
            if batch.objects.filter(Q(batchname__iexact=batch_name) & Q(batch_type=batch_type)).exists():
               messages.error(request, 'Batch with the name already exists.')
            else:
                forms.save()
                messages.success(request, 'Batch registerd successfully.')
                forms = BatchForm()
        # else:
        #     messages.error(request, 'Invalid form submission. Please check the entered data.')

        return render(request, 'adminaddbatch.html', {'form': forms})
    else:
        forms = BatchForm()
        return render(request, 'adminaddbatch.html', {'form': forms})

def adminaddtime(request):
    if request.method=='POST':
        forms = clubbatchtimeform(request.POST, request.FILES)
        if forms.is_valid():
            print("postok")
            forms.save()
            forms=clubbatchtimeform()
        list = sportsitem.objects.all()
        return render(request, 'adminaddbatchtime.html', {'form': forms, 'list1': list})
    else:
        forms = clubbatchtimeform()
        list=sportsitem.objects.all()
        return render(request, 'adminaddbatchtime.html', {'form': forms,'list1':list})


# def adminaddtime(request):
#     if request.method=='POST':
#         forms=clubbatchtimeform(request.POST,request.FILES)
#         if forms.is_valid():
#             forms.save()
#             forms=clubbatchtimeform()
#             return render(request,'adminaddbatchtime.html',{'form':forms})
#     else:
#          list1 = sportsitem.objects.all()
#          forms = clubbatchtimeform()
#          return render(request, 'adminaddbatchtime.html', {'form': forms})
def adminviewsportsitem(request):
    list=sportsitem.objects.all()
    return render(request,'adminviewsportsitem.html',{'list':list})
def admindeletesportsitem(request,pk):
    form=sportsitem.objects.get(id=pk)
    form.delete()
    return redirect('viewsportsitem')
def admineditsportsitem(request,pk):

    cu_ed = sportsitem.objects.get(id=pk)

    if request.method == 'POST':
        updated_form = sportsitemform(request.POST, request.FILES, instance=cu_ed)
        if updated_form.is_valid():
            item_name = updated_form.cleaned_data['item_name']
            # if batch.objects.filter(Q(batchname__iexact=batch_name) & Q(batch_type=batch_type) & ~Q(id=pk)).exists():

            if sportsitem.objects.filter(Q(item_name__iexact=item_name) & ~Q(id=pk)).exists():
                messages.error(request, 'sports item with this name already exist')
            else:
                updated_form.save()
                messages.success(request, 'Item updated successfully.')
                # return redirect('viewsportsitem')
                form = sportsitemform(instance=cu_ed)
                return render(request, 'admineditsportsitem.html', {'form': form})


    else:

        form = sportsitemform(instance=cu_ed)
        messages.success(request, '')
        return render(request, 'admineditsportsitem.html', {'form': form})




def adminviewgallary(request):
    list=clubgallery.objects.all()
    # context={'list':list}
    return render(request, 'adminviewgallary.html', {'list': list})
def deleteimage(request,pk):
    form=clubgallery.objects.get(id=pk)
    form.delete()
    return redirect('adminviewgallary')
def adminlistbatch(request):
    if request.method == 'POST':
        batch_type = request.POST.get('batchtype')
        if batch_type=='ALL':
            list = batch.objects.all()
            list1 = sportsitem.objects.all()
            return render(request, 'adminviewbatch.html', {'list': list, 'list1': list1})
        else:
            list = batch.objects.filter(batch_type=batch_type)
            list1 = sportsitem.objects.all()
            return render(request, 'adminviewbatch.html', {'list': list, 'list1': list1})




        # return redirect('adminviewgallary')
    else:
        list=batch.objects.all()
        list1=sportsitem.objects.all()
        return render(request,'adminviewbatch.html',{'list':list,'list1':list1})
def deletebatch(request,pk):
    form=batch.objects.get(id=pk)
    form.delete()
    form1=batchtime.objects.filter(batid=pk)
    form1.delete()
    return redirect('adminbatchlist')


def admineditbatch(request, pk):
    cu_ed = batch.objects.get(id=pk)
    if request.method == 'POST':
        updated_form = BatchForm(request.POST, request.FILES, instance=cu_ed)
        if updated_form.is_valid():
            batch_name = updated_form.cleaned_data['batchname']
            batch_type=updated_form.cleaned_data['batch_type']
            #if batch.objects.filter(Q(batchname__iexact=batch_name) and id!=pk).exists():
            if batch.objects.filter(Q(batchname__iexact=batch_name) & Q(batch_type=batch_type) & ~Q(id=pk)).exists():
                messages.error(request,'Batch name already exists.')
                form = BatchForm(instance=cu_ed)
                return render(request,'admineditbatch.html', {'form': form})
            else:
                updated_form.save()
                #messages.success(request,'Batch updated successfully.')
                return redirect('adminbatchlist')
    else:
        form = BatchForm(instance=cu_ed)
        return render(request, 'admineditbatch.html', {'form': form})


# def admineditbatch(request,pk):
#      cu_ed = batch.objects.get(id=pk)
#      if request.method=='POST':
#         updated_form = BatchForm(request.POST, request.FILES, instance=cu_ed)
#         if updated_form.is_valid():
#             updated_form.save()
#             return redirect('adminbatchlist')
#      else:
#
#         form = BatchForm(instance=cu_ed)
#         return render(request, 'admineditbatch.html', {'form': form})

def adminviewbatchtime1(request, pk, pk3):
        selected_batch = batch.objects.get(id=pk)
        item=pk3
        # print(item)
        ######
        current_page_url = request.build_absolute_uri()
        request.session['previous_page'] = current_page_url
        # previous_page_url = request.META.get('HTTP_REFERER', '/')
        # request.session['previous_page'] = previous_page_url
    #####


        if selected_batch:
            # print("ok")
            pk1 = selected_batch.batchname
            pk2 = selected_batch.id
            # print(pk1)
            # print(pk2)
            list1 = batchtime.objects.filter(batid=pk2)

            return render(request, 'adminviewbatchtime.html', {'list1': list1,'batch_type':pk3})
        else:
            return redirect('adminbatchlist')
def adminviewbatchtime(request, pk):
         selected_batch = batch.objects.get(id=pk)

         if selected_batch:
             pk1 = selected_batch.batchname
             pk2 = selected_batch.id

             list1 = batchtime.objects.filter(batid=pk2)

             return render(request, 'adminviewbatchtime.html', {'list1': list1})
         else:
             return redirect('adminbatchlist')
def admindeletebatchtime(request,pk):
    form=batchtime.objects.get(batchtimeid=pk)
    form.delete()
    return redirect('adminbatchlist')
def admineditbatchtime(request,pk):

    cu_ed = batchtime.objects.get(batchtimeid=pk)
    if request.method=="POST":
        updated_form = clubbatchtimeform(request.POST,instance=cu_ed)
        if updated_form.is_valid():
            updated_form.save()


            previous_page_url = request.session.get('previous_page', '/')

            return redirect(previous_page_url)


    else:
        updated_form = clubbatchtimeform(instance=cu_ed)
    return render(request,'admineditbatchtime.html',{'form':updated_form})
# def addclubnews(request):
#     if request.method == "POST":
#         forms = clubnewsform(request.POST, request.FILES)  # Include request.FILES for file uploads
#         if forms.is_valid():
#             print("haiii")
#             forms.save()
#             return render(request, 'adminaddclubnew.html', {'form': forms})
#         else:
#             return render(request, 'adminaddclubnew.html', {'form': forms})
#
#     else:
#         forms = clubnewsform()
#         return render(request, 'adminaddclubnew.html', {'form': forms})

def addclubnews(request):
    if request.method == "POST":
        forms = clubnewsform(request.POST, request.FILES)
        if forms.is_valid():
            forms.save()
            return render(request, 'adminaddclubnew.html', {'form': clubnewsform()})
        # If the form is invalid, show the form with errors
        return render(request, 'adminaddclubnew.html', {'form': forms})

    else:
        forms = clubnewsform()
        return render(request, 'adminaddclubnew.html', {'form': forms})


def adminviewnews(request):
    list=newstb.objects.all()
    return render(request, 'adminviewclubnews.html', {'list': list})

def admindeletenews(request,pk):
    form=newstb.objects.get(newsid=pk)
    form.delete()
    return redirect('adminnewslist')
def adminviewmembers(request):
    list=clubmember.objects.all()
    return render(request,'adminviewmembers.html',{'list':list})
def adminviewmemberprofile(request,pk):
    form=clubmember.objects.get(id=pk)
    return render(request,'adminviewmemberprofile.html',{'form':form})
def adminviewgroundbooking(request):
    list=groundbooking.objects.all()
    return render(request,'adminviewgroundbooking.html',{'list':list})
def viewpaymentdetails(request):
    return render(request,'viewpayment.html')




def adminapprovebooking(request, pk):
    booking = groundbooking.objects.get(bookid=pk)
    if booking:
        #print(booking.bookstatus)
        if booking.bookstatus.strip() == 'Pending' or 'Reject':

            booking.bookstatus = 'Approved'
            booking.save()

    return redirect('viewgroundbooking')
def adminrejectbooking(request, pk):
    booking = groundbooking.objects.get(bookid=pk)
    if booking:
        #print(booking.bookstatus)
        if booking.bookstatus.strip() == 'Pending' or 'Approved':

            booking.bookstatus = 'Reject'
            booking.save()
    return redirect('viewgroundbooking')

def adminviewregistredbatch(request):
    list1 = sportsitem.objects.all()
    if request.method == 'POST':
        batchtype1 = request.POST.get('batchtype')
        if batchtype1=='ALL':
            list = batchregister.objects.all()
            return render(request, 'adminviewbatchregister.html', {'list': list, 'list1': list1})
        else:
            list2 = batch.objects.filter(batch_type=batchtype1)
            print(list2)
            list = []

            for x in list2:
                print(x.id)
                print(x.batchname)# correct
                for y in batchtime.objects.filter(batid=x.id):
                    print(y.batchtimeid)
                    list3 = []
                    list3 += batchregister.objects.filter(batchid=y.batchtimeid)
                    list += list3

            return render(request, 'adminviewbatchregister.html', {'list': list, 'list1': list1})
    else:
        list = batchregister.objects.all()
        return render(request, 'adminviewbatchregister.html', {'list': list, 'list1': list1})

def adminaddpurpose(request):
    if request.method=='POST':
        forms=puposeform(request.POST,request.FILES)
        if forms.is_valid():

            item_name = forms.cleaned_data['purpose_name']
            if purpose.objects.filter(Q(purpose_name__iexact=item_name)).exists():
                messages.error(request, 'purpose with this name already exist')
            else:
                forms.save()
                messages.success(request, ' registered successfully.')
                form = sportsitemform()

                forms=puposeform()
                return render(request,'admintaddpurpose.html',{'form':forms})
        else:
            forms = puposeform()
            return render(request, 'admintaddpurpose.html', {'form': forms})
    else:
        forms = puposeform()
        return render(request, 'admintaddpurpose.html', {'form': forms})
def adminviewbookingpurpose(request):
    list=purpose.objects.all()
    return render(request,'adminviewpurose.html',{'list':list})
def admindeletepurpose(request,pk):
    list=purpose.objects.get(purposeid=pk)
    list.delete()
    return redirect('viewpurpose')

def admineditpurpose(request,pk):
    list=purpose.objects.get(purposeid=pk)
    if(request.method=="POST"):
        update_form=puposeform(request.POST,request.FILES,instance=list)
        if update_form.is_valid():
            update_form.save()
            return redirect('viewpurpose')
        else:
            form=puposeform(instance=list)
            return redirect('viewpurpose')
    else:
        form=puposeform(instance=list)
        return render(request, 'admineditpurpose.html', {'form': form})
def getbatches(request,pk):
    print(pk)
    batches =batch.objects.all(batch_type=pk).values('id', 'batch_name')
    batches_list = list(batches)
    return JsonResponse({'batches': batches_list})


def get_batch_options(request):

    if request.method == 'POST':
        selected_batch_type_id = request.POST.get('batch_type')

        try:
            batch_options = batch.objects.filter(batch_type=selected_batch_type_id)
        except batch.DoesNotExist:
            return JsonResponse({'error': 'Invalid Batch Type'}, status=400)
        batch_options_list = [{'id': batch.id, 'item_name': batch.batchname} for batch in batch_options]

        return JsonResponse({'batches': batch_options_list})
    else:
        return JsonResponse({'error': 'Invalid method'}, status=400)

class groundbookingcreateview(generics.ListCreateAPIView):
    queryset = groundbooking.objects.all()
    serializer_class=groundbookingserializer

# api login

# class UserLoginapi(APIView):
#     # permission_classes = (AllowAny,)
#     # authentication_classes = tuple()
#
#     def get(self, request):
#         response_dict = {"status": False}
#         response_dict["logged_in"] = bool(request.user.is_authenticated)
#         # response_dict["status"] = True
#         return Response(response_dict, HTTP_200_OK)
#
#     def post(self, request):
#         response_dict = {"status": False, "token": None, "redirect": False}
#         password = request.data.get("password")
#         username = request.data.get("username")
#         try:
#             t_user = Userprofile.objects.get(username=username)
#
#         except Userprofile.DoesNotExist:
#             response_dict["reason"] = "No account found for this username. Please signup."
#             return Response(response_dict, HTTP_200_OK)
#         authenticated = authenticate(username=t_user.username,password=password)
#         if not authenticated:
#             response_dict["reason"] = "Invalid credentials."
#             return Response(response_dict, HTTP_200_OK)
#         user = t_user
#         if not user.is_active:
#             response_dict["reason"] = "Your login is inactive! Please contact admin"
#             return Response(response_dict, HTTP_200_OK)
#
#         session_dict = {"real_user": authenticated.id}
#         token, _ = Token.objects.get_or_create(
#             user=user, defaults={"session_dict": json.dumps(session_dict)}
#         )
#         login(request, user, "django.contrib.auth.backends.ModelBackend")
#         response_dict["session_data"] = {
#             "user_id": user.id,
#             "user_type": user.user_type,
#             "token": token.key,
#             # "status": user.status,
#         }
#         response_dict["token"] = token.key
#         # response_dict["status"] = True
#         return Response(response_dict,HTTP_200_OK)

#APIview to get gallary

# class ClubGalleryView(APIView):
#     def get(self, request):
#         galleries = clubgallery.objects.all()
#         serializer = ClubGallerySerializer(galleries, many=True)
#         return Response(serializer.data)

class ClubGalleryView(APIView):
    def get(self, request):
        response_dict = {"status": False, "data": None}
        galleries = clubgallery.objects.all()
        serializer = ClubGallerySerializer(galleries, many=True, context={'request': request})
        response_dict["status"] = True
        response_dict["data"] = serializer.data
        return Response(response_dict,HTTP_200_OK)


#API View to get news

class NewsView(APIView):
    def get(self, request):
        news = newstb.objects.all()
        serializer = NewsSerializer(news, many=True)
        return Response(serializer.data,HTTP_200_OK)
class Sportsitemview(APIView):
    def get(self, request):
        s_item = sportsitem.objects.all()
        serializer = SportsItemSerializer(s_item, many=True)
        return Response(serializer.data,HTTP_200_OK)

class Batchview(APIView):
    def get(self, request,pk):
        batch_item = batch.objects.filter(batch_type=pk)
        serializer = BatchSerializer(batch_item, many=True)
        return Response(serializer.data,HTTP_200_OK)

class Batchtimeview(APIView):
    def get(self, request,pk):

        batchtime_item = batchtime.objects.filter(batid=pk)
        serializer = BatchTimeSerializer(batchtime_item, many=True)
        return Response(serializer.data,HTTP_200_OK)
# class Viewmemberprofile(APIView):
#     def get (self,request,pk):
#         memdetails=clubmember.objects.filter(id=pk)
#         serializer = clubmemberSerializer(memdetails, many=True)
#         return Response(serializer.data, HTTP_200_OK)
class Viewmemberprofile(APIView):
    def get(self, request, pk):
        memdetails = clubmember.objects.filter(id=pk).first()
        if memdetails:
            serializer = clubmemberSerializer(memdetails, context={'request': request})  # Pass request object to context
            return Response(serializer.data, status=HTTP_200_OK)
        else:
            return Response({"message": "Member not found"}, status=HTTP_404_NOT_FOUND)
class purposeview(APIView):
    def get(self, request):
        item_purpose = purpose.objects.all()
        serializer = PurposeSerializer(item_purpose, many=True)
        return Response(serializer.data,HTTP_200_OK)
class groundbookingdateview(APIView):
    def get(self, request):
        # Filter groundbooking instances by bookstatus='Approved'
        approved_bookings = groundbooking.objects.filter(bookstatus='Approved')
        # Extract bookdate from the filtered instances
        bookdates = approved_bookings.values_list('bookdate', flat=True)
        # Convert the queryset to a list
        bookdate_list = list(bookdates)
        # Return the bookdate list in the response
        return Response(bookdate_list, status=status.HTTP_200_OK)
class UserLoginapi(APIView):
    permission_classes = (AllowAny,)
    # authentication_classes = tuple()

    def get(self, request):
        print("login")
        response_dict = {"status": False}
        response_dict["logged_in"] = bool(request.user.is_authenticated)
        # response_dict["status"] = True
        return Response(response_dict, HTTP_200_OK)

    def post(self, request):
        response_dict = {"status": False, "token": None, "redirect": False,"memuid":None}
        password = request.data.get("password")
        username = request.data.get("username")
        print(username)
        print(password)
        try:
            t_user = Userprofile.objects.get(username=username)

        except Userprofile.DoesNotExist:
            response_dict["reason"] = "No account found for this username. Please signup."
            return Response(response_dict, HTTP_200_OK)
        authenticated = authenticate(username=t_user.username,password=password)
        if not authenticated:
            response_dict["reason"] = "Invalid credentials."
            return Response(response_dict, HTTP_200_OK)
        user = t_user
        if not user.is_active:
            response_dict["reason"] = "Your login is inactive! Please contact admin"
            return Response(response_dict, HTTP_200_OK)

        session_dict = {"real_user": authenticated.id}
        token, _ = Token.objects.get_or_create(
            user=user, defaults={"session_dict": json.dumps(session_dict)}
        )
        li=clubmember.objects.filter(member=user.id).first()
        memuid=li.id
        # memname=li.name
        # memaddress=li.address
        # mememail=li.email
        # memph=li.phoneno
        # memdob=li.date_of_birth
        # memgen=li.gender
        # memph=li.photo
        # memoj=li.date_of_join
        login(request, user, "django.contrib.auth.backends.ModelBackend")
        response_dict["session_data"] = {
            "user_id": user.id,
            "user_type": user.user_type,
            "token": token.key,
            "memuid":memuid,
            # "memname":memname,
            # "mememail":mememail,
            # "memph":memph,
            # "status": user.status,
        }
        response_dict["token"] = token.key
        # response_dict["status"] = True
        return Response(response_dict,HTTP_200_OK)

class BatchregisterAPI(APIView):
        permission_classes = [AllowAny]

        def post(self, request, *args, **kwargs):
            # Serialize and validate user data
            batch_serializer = BatchRegisterSerializer(data=request.data)
            if batch_serializer.is_valid():
                # Save the booking
                batch_serializer.save()
                return Response(batch_serializer.data, status=status.HTTP_201_CREATED)
            else:
                # Handle the case where serializer is not valid
                return Response(batch_serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# class GroundbookingAPI(generics.CreateAPIView):
#     queryset = groundbooking.objects.all()
#     serializer_class = GroundBookingSerializer
#     permission_classes = [AllowAny]
#
#     def post(self, request, *args, **kwargs):
#         # Serialize and validate user data
#         book_data = {
#             'membid': request.data.get('user_id'),
#             'purpose': request.data.get('purpose'),
#             'bookdate': request.data.get('booking_date'),
#             'bookeddate': request.data.get('booked_date'),
#             'amount': request.data.get('amount'),
#         }
#
#         # Serialize and validate club member data
#         booking_serializer = GroundBookingSerializer(data=book_data)
#         if booking_serializer.is_valid():
#             # Create club member object
#             groundbook = booking_serializer.save()
#             return Response(booking_serializer.data, status=status.HTTP_201_CREATED)
#         else:
#             # Handle the case where serializer is not valid
#             return Response(booking_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
class GroundbookingAPI(APIView):
    permission_classes = [AllowAny]

    def post(self, request, *args, **kwargs):
        # Serialize and validate user data
        booking_serializer = GroundBookingSerializer(data=request.data)
        if booking_serializer.is_valid():
            # Save the booking
            booking_serializer.save()
            return Response(booking_serializer.data, status=status.HTTP_201_CREATED)
        else:
            # Handle the case where serializer is not valid
            return Response(booking_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
class Accountview(APIView):
    def get(self, request,pk):
        account_detail = memberaccount.objects.filter(member=pk)
        serializer = MemberAccountSerializer(account_detail, many=True)
        return Response(serializer.data,HTTP_200_OK)


class GroundBookingList(generics.ListCreateAPIView):
    serializer_class = GroundBookingSerializer

    def get_queryset(self):
        """
        This view should return a list of all the ground bookings
        for the specified member.
        """
        member_id = self.kwargs['pk']
        queryset = groundbooking.objects.filter(membid=member_id)
        return queryset

    def get(self, request, *args, **kwargs):
        member_id = self.kwargs['pk']
        queryset = self.get_queryset().filter(membid=member_id)
        serializer = GroundBookingSerializer1(queryset, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
class GroundBookingPaymentView(APIView):
    def post(self, request, pk, amount):
        # Retrieve the member account detail
        account_detail = memberaccount.objects.filter(member=pk).first()

        if account_detail:
            # Check if the account balance is sufficient for the payment
            if int(account_detail.amount) >= amount:
                # Update the account balance
                new_balance = int(account_detail.amount) - amount
                account_detail.amount = new_balance
                account_detail.save()

                # Serialize the updated account detail
                serializer = MemberAccountSerializer(account_detail)

                # Return a success response with the updated data
                return Response(serializer.data, status=status.HTTP_200_OK)
            else:
                # Return an error response if the account balance is insufficient
                return Response({"message": "Insufficient account balance"}, status=status.HTTP_400_BAD_REQUEST)
        else:
            # Return an error response if the account detail is not found
            return Response({"message": "Account detail not found"}, status=status.HTTP_404_NOT_FOUND)

class UpdateMemberProfile(APIView):
    def put(self, request, pk):
        try:
            member = clubmember.objects.get(pk=pk)
        except clubmember.DoesNotExist:
            return Response({"message": "Member not found"}, status=status.HTTP_404_NOT_FOUND)

        serializer = clubmemberSerializer1(member, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
# class BatchbookingPaymentView(APIView):
#     def post(self, request, pk, amount):
#         # Retrieve the member account detail
#         account_detail = memberaccount.objects.filter(member=pk).first()
#
#         if account_detail:
#             # Check if the account balance is sufficient for the payment
#             if int(account_detail.amount) >= amount:
#                 # Update the account balance
#                 new_balance = int(account_detail.amount) - amount
#                 account_detail.amount = new_balance
#                 account_detail.save()
#
#                 # Serialize the updated account detail
#                 serializer = MemberAccountSerializer(account_detail)
#
#                 # Return a success response with the updated data
#                 return Response(serializer.data, status=status.HTTP_200_OK)
#             else:
#                 # Return an error response if the account balance is insufficient
#                 return Response({"message": "Insufficient account balance"}, status=status.HTTP_400_BAD_REQUEST)
#         else:
#             # Return an error response if the account detail is not found
#             return Response({"message": "Account detail not found"}, status=status.HTTP_404_NOT_FOUND)
class UserBatchregisterview(APIView):
    def get(self, request,pk):
        batchreg_item = batchregister.objects.filter(membid=pk)
        print(batchreg_item)
        serializer = BatchRegisterSerializer(batchreg_item, many=True)
        return Response(serializer.data,HTTP_200_OK)
# def logout_admin(request):
#     logout(request)
#     return redirect('login')

def logout_admin(request):
    logout(request)
    response = redirect('login')
    # response['Cache-Control'] = 'no-cache, no-store, must-revalidate, max-age=0'
    # # response['Cache-Control'] = 'no-cache, no-store, must-revalidate'  # HTTP 1.1
    # response['Pragma'] = 'no-cache'  # HTTP 1.0
    # response['Expires'] = '0'  # Proxies
    return response


# class ForgotPasswordAPIView(APIView):
#         permission_classes = [AllowAny]
#
#         def post(self, request):
#             serializer = ForgotPasswordSerializer(data=request.data)
#             if serializer.is_valid():
#                 # username = serializer.validated_data['username']
#                 email = serializer.validated_data['email']
#                 print(email)
#                 try:
#                     user = User.objects.get(email=email)
#                 except User.DoesNotExist:
#                     return Response({'detail': 'User not found.'}, status=status.HTTP_404_NOT_FOUND)
#
#                 # Generate OTP
#                 otp = get_random_string(length=4, allowed_chars='0123456789')
#
#                 # Save OTP to user model (you may need to add a field for this)
#                 user.otp = otp
#                 user.save()
#
#                 # Send OTP through email
#                 send_mail(
#                     'Forgot Password OTP',
#                     f'Canteen Management System Your OTP is: {otp}',
#                     'from@example.com',
#                     [email],
#                     fail_silently=False,
#                 )
#
#                 return Response({'detail': 'OTP sent successfully.'}, status=status.HTTP_200_OK)
#             return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class ForgotPasswordAPIView(APIView):
        permission_classes = [AllowAny]

        def post(self, request):
            serializer = ForgotPasswordSerializer(data=request.data)
            if serializer.is_valid():
                # username = serializer.validated_data['username']
                email = serializer.validated_data['email']
                print(email)
                try:
                    user = clubmember.objects.get(email=email)
                except clubmember.DoesNotExist:
                    return Response({'detail': 'User not found.'}, status=status.HTTP_404_NOT_FOUND)

                # Generate OTP
                otp = get_random_string(length=4, allowed_chars='0123456789')

                # Save OTP to user model (you may need to add a field for this)
                user.otp = otp
                user.save()

                # Send OTP through email
                send_mail(
                    'Forgot Password OTP',
                    f'Club Management System Your OTP is: {otp}',
                    'from@example.com',
                    [email],
                    fail_silently=False,
                )

                return Response({'detail': 'OTP sent successfully.'}, status=status.HTTP_200_OK)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)





class PasswordChangeAPIView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        serializer = PasswordChangeSerializer(data=request.data)
        if serializer.is_valid():
            email = serializer.validated_data['email']
            otp = serializer.validated_data['otp']
            new_password = serializer.validated_data['new_password']
            print('hhii')
            print(email)
            print(otp)
            print(new_password)
            # Check if the user exists and OTP is valid
            try:
                user = clubmember.objects.get(email=email, otp=otp)
            except clubmember.DoesNotExist:
                return Response({'error': 'Invalid user ID or OTP'}, status=status.HTTP_400_BAD_REQUEST)

            # Change the password
            user.member.set_password(new_password)
            user.member.save()

            return Response({'message': 'Password changed successfully'}, status=status.HTTP_200_OK)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class Clubprofilehelp(APIView):
    def get(self, request):
        item_clubprofile = clubprofile.objects.first()
        serializer = ClubProfileSerializer(item_clubprofile)
        return Response(serializer.data, status=HTTP_200_OK)