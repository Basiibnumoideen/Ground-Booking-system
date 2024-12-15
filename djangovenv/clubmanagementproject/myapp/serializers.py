from rest_framework import serializers
from .models import *
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = Userprofile
        fields = ['id', 'username', 'password','user_type']
class LoginSerializer(serializers.ModelSerializer):
    class Meta:
        model=Userprofile
        fields=['username','password']

class clubmemberSerializer(serializers.ModelSerializer):
    photo = serializers.SerializerMethodField()

    def get_photo(self, obj):
        if obj.photo:
            return self.context['request'].build_absolute_uri(obj.photo.url)
        return None

    class Meta:
        model = clubmember
        fields = ['id', 'name', 'member', 'address', 'email', 'phoneno', 'date_of_birth', 'gender', 'photo', 'date_of_join']

class clubmemberSerializer1(serializers.ModelSerializer):
    class Meta:
        model = clubmember
        fields = ['id', 'name', 'member', 'address', 'email', 'phoneno', 'date_of_birth', 'gender', 'photo', 'date_of_join']


# class clubmemberSerializer(serializers.ModelSerializer):
#     # photo = serializers.SerializerMethodField()
#
#     # def get_photo(self,obj):
#     #     # Assuming 'image' field stores the filename of the image
#     #     # Replace 'YOUR_DOMAIN' with the actual domain where your images are hosted
#     #     return self.context['request'].build_absolute_uri(obj.photo.url)
#     class Meta:
#         model=clubmember
#         fields=['id','name','member','address','email','phoneno','date_of_birth','gender','photo','date_of_join']
class memberaccountserializer(serializers.ModelSerializer):
    class Meta:
        model=memberaccount
        fields=['id','account_number','IFSC','key','amount','member']
class groundbookingserializer(serializers.ModelSerializer):
        class Meta:
            model = groundbooking
            fields = ['membid', 'purpose', 'fromdate','days','todate','bookdate','amount','bookstatus','paymentstatus']

class ClubGallerySerializer(serializers.ModelSerializer):
    img = serializers.SerializerMethodField()

    def get_img(self, obj):
        # Assuming 'image' field stores the filename of the image
        # Replace 'YOUR_DOMAIN' with the actual domain where your images are hosted
        return self.context['request'].build_absolute_uri(obj.img.url)

    class Meta:
        model = clubgallery
        fields = ['id', 'img']

class NewsSerializer(serializers.ModelSerializer):
    class Meta:
        model = newstb
        fields = ['newsid', 'news', 'date']
class SportsItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = sportsitem
        fields = ['id', 'item_name', 'description']
class BatchSerializer(serializers.ModelSerializer):
    class Meta:
        model = batch
        fields = ['id', 'batch_type', 'batchname', 'description', 'paymentperday']
class BatchTimeSerializer(serializers.ModelSerializer):
    class Meta:
        model = batchtime
        fields = ['batchtimeid', 'batid', 'fromtime', 'totime']

class PurposeSerializer(serializers.ModelSerializer):
    class Meta:
        model = purpose
        fields = ['purposeid', 'purpose_name', 'payment_perday']
class GroundBookingSerializer(serializers.ModelSerializer):
    class Meta:
        model = groundbooking
        fields = [ 'membid', 'purpose', 'bookdate', 'bookeddate', 'amount']

class BatchRegisterSerializer(serializers.ModelSerializer):
    class Meta:
        model = batchregister
        fields = ['membid','Sportsitem','batch', 'batchid','batchtime', 'fromdate', 'todate', 'amount']

class GroundBookingSerializer1(serializers.ModelSerializer):
    purpose = serializers.StringRelatedField()  # This will display the purpose name

    class Meta:
        model = groundbooking
        fields = [ 'bookid','membid', 'purpose', 'bookdate', 'bookeddate', 'amount','bookstatus','paymentstatus']




class MemberAccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = memberaccount
        fields = ['id', 'account_number', 'IFSC', 'key', 'amount', 'member']
# class BatchregisterSerializer1(serializers.ModelSerializer):
#     purpose = serializers.StringRelatedField()  # This will display the purpose name
#
#     class Meta:
#         model = groundbooking
#         fields = [ 'bookid','membid', 'purpose', 'bookdate', 'bookeddate', 'amount','bookstatus','paymentstatus']

class ForgotPasswordSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(required=True)
    class Meta:
        model=clubmember
        fields=['email']
class PasswordChangeSerializer(serializers.Serializer):
    email = serializers.CharField()
    otp = serializers.CharField()
    new_password = serializers.CharField()
class clubmemberSerializer3(serializers.ModelSerializer):
    # photo = serializers.SerializerMethodField()

    def get_photo(self, obj):
        if obj.photo:
            return self.context['request'].build_absolute_uri(obj.photo.url)
        return None

    class Meta:
        model = clubmember
        fields = ['id', 'name', 'member', 'address', 'email', 'phoneno', 'date_of_birth', 'gender', 'photo','date_of_join']


class ClubProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = clubprofile
        fields = ['id', 'name', 'profileimg', 'clubadmin', 'contactno', 'emailid', 'description']