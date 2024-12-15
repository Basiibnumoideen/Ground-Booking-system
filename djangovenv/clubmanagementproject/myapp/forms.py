from django.contrib.auth.forms import UserCreationForm

from .models import clubgallery,batch,newstb,clubprofile,batchtime,purpose,Userprofile,sportsitem
from django import  forms

class uploadgallaryform(forms.ModelForm):
    class Meta:
        model=clubgallery
        fields=['id','img']

class AdminLogForm(UserCreationForm):
    user_type = forms.CharField(widget=forms.HiddenInput(), initial='admin')
    class Meta:
        model = Userprofile
        fields = ('username', 'password1', 'password2')

class ClubProfileForm(forms.ModelForm):
    class Meta:
        model = clubprofile
        fields = ('name', 'profileimg', 'clubadmin', 'contactno', 'emailid', 'description')
class Loginform(forms.Form):
    username = forms.CharField()
    password = forms.CharField(widget=forms.PasswordInput)
class sportsitemform(forms.ModelForm):
    class Meta:
        model=sportsitem
        fields=['item_name','description']
class BatchForm(forms.ModelForm):
    class Meta:
        model = batch
        fields = ['id','batch_type','batchname', 'description', 'paymentperday']
class clubbatchtimeform(forms.ModelForm):
    class Meta:
        model=batchtime
        fields=['batid','fromtime','totime']

class clubnewsform(forms.ModelForm):
    class Meta:
        model=newstb
        fields=['news']



class puposeform(forms.ModelForm):
    class Meta:
        model=purpose
        fields=['purpose_name','payment_perday']