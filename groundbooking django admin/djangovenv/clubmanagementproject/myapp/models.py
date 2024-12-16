from django.utils import timezone
from django.contrib.auth.models import User #1111
from django.contrib.auth.models import  AbstractUser
from django.db import models
import random,string,json

# class Customuser(AbstractUser):
#     pass

USER_TYPE_CHOICES=(
    ("CLUB_ADMIN","Club Admin"),
    ("MEMBER","Member"),

)
STATUS_CHOICE=(
("ACTIVE","Active"),
("DEACTIVE","Deactive"),
)

class Userprofile(AbstractUser):
    #username
    #password
    user_type=models.CharField(
        max_length=50,null=False,blank=False,choices=USER_TYPE_CHOICES
    )
    is_active = models.BooleanField(null=False,blank=True,default=True)
    def __str__(self):
        return str(self.username)

class Token(models.Model):
    key = models.CharField(max_length=50, unique=True)
    user = models.OneToOneField(
        Userprofile,
        related_name="auth_tokens",
        on_delete=models.CASCADE,
        verbose_name="user",
        unique=True,
        null=True,
        blank=True,
    )
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)
    session_dict = models.TextField(null=False, default="{}")

    dict_ready = False
    data_dict = None

    def _init_(self, *args, **kwargs):
        self.dict_ready = False
        self.data_dict = None
        super(Token, self)._init_(*args, **kwargs)

    def generate_key(self):
        return "".join(
            random.choice(
                string.ascii_lowercase + string.digits + string.ascii_uppercase
            )
            for i in range(40)
        )

    def save(self, *args, **kwargs):
        if not self.key:
            new_key = self.generate_key()
            while type(self).objects.filter(key=new_key).exists():
                new_key = self.generate_key()
            self.key = new_key
        return super(Token, self).save(*args, **kwargs)

    def read_session(self):
        if self.session_dict == "null":
            self.data_dict = {}
        else:
            self.data_dict = json.loads(self.session_dict)
        self.dict_ready = True

    def update_session(self, tdict, save=True, clear=False):
        if not clear and not self.dict_ready:
            self.read_session()
        if clear:
            self.data_dict = tdict
            self.dict_ready = True
        else:
            for key, value in tdict.items():
                self.data_dict[key] = value
        if save:
            self.write_back()

    def set(self, key, value, save=True):
        if not self.dict_ready:
            self.read_session()
        self.data_dict[key] = value
        if save:
            self.write_back()

    def write_back(self):
        self.session_dict = json.dumps(self.data_dict)
        self.save()

    def get(self, key, default=None):
        if not self.dict_ready:
            self.read_session()
        return self.data_dict.get(key, default)

    def _str_(self):
        return str(self.user) if self.user else str(self.id)



class clubmember(models.Model):
    id=models.AutoField(primary_key=True)
    name=models.CharField(max_length=50)
    member = models.OneToOneField(
        Userprofile,
        on_delete=models.CASCADE,
        blank=True,
        null=True
    )
    address=models.TextField()
    email=models.CharField(max_length=50)
    phoneno=models.IntegerField()
    date_of_birth = models.DateField()
    gender=models.TextField(max_length=50)
    photo=models.ImageField(upload_to='memberimg',null=True,blank=True)
    date_of_join = models.DateTimeField(auto_now_add=True)
    is_active = models.BooleanField(null=False, blank=True, default=True)
    otp = models.CharField(max_length=20, null=True, blank=True)
    def __str__(self):
        return str(self.name)

class memberaccount(models.Model):
    id=models.AutoField(primary_key=True)
    account_number=models.CharField(max_length=50)
    IFSC=models.CharField(max_length=50)
    key=models.CharField(max_length=50)
    amount=models.CharField(max_length=50)
    member = models.ForeignKey(
        clubmember,
        on_delete=models.CASCADE,
        blank=True,
        null=True
    )


class sportsitem(models.Model):
    id=models.AutoField(primary_key=True)
    item_name=models.CharField(max_length=50)
    description=models.TextField(max_length=100)
    def __str__(self):
        return str(self.item_name)

# Create your models here.
class clubprofile(models.Model):
    id=models.AutoField(primary_key=True)
    name=models.CharField(max_length=50)
    profileimg=models.ImageField(upload_to='clubprofile',unique=True)
    clubadmin=models.CharField(max_length=50)
    contactno=models.IntegerField(max_length=10)
    emailid=models.EmailField()
    description=models.TextField(max_length=100)
    user=models.OneToOneField(Userprofile,on_delete=models.CASCADE,null=True)
    user_type=models.CharField(max_length=50)

    def __str__(self):
        return str(self.name)
class clubgallery(models.Model):
    id=models.AutoField(primary_key=True)
    img = models.ImageField(upload_to='gallary',unique=True)
    def __srt__(self):
        return str(self.id)



class batch(models.Model):
    id = models.AutoField(primary_key=True)
    batch_type=models.ForeignKey(sportsitem,on_delete=models.CASCADE)
    batchname = models.CharField(max_length=50)
    description = models.TextField()  # Parentheses added here
    paymentperday = models.IntegerField()  # Parentheses added here

    def __str__(self):
        return str(self.batchname)


class batchtime(models.Model):
    batchtimeid=models.AutoField(primary_key=True)
    batid=models.ForeignKey(batch,on_delete=models.CASCADE)
    fromtime=models.CharField(max_length=50)
    totime=models.CharField(max_length=50)
    def __str__(self):
        return str(self.batchtimeid)

class gender (models.Model):
    id=models.AutoField(primary_key=True)
    gen=models.CharField(max_length=50,unique=True)
    def __str__(self):
        return str(self.gen)

class batchregister(models.Model):
    regid=models.AutoField(primary_key=True)
    membid=models.ForeignKey(clubmember,on_delete=models.CASCADE)
    Sportsitem=models.CharField(max_length=50,null=True,blank=True)
    batch=models.CharField(max_length=50,null=True,blank=True)

    batchid=models.ForeignKey(batchtime,on_delete=models.CASCADE)
    batchtime=models.CharField(max_length=50,null=True,blank=True)
    fromdate=models.DateField()
    todate=models.DateField()
    amount=models.IntegerField(default=0)
    paymentstatus=models.CharField(max_length=50,default="Complete")
    batchstatus=models.CharField(max_length=50,default="Approved")
    def __str__(self):
        return str(self.regid)
    # def save(self, *args, **kwargs):
    #     if self.todate and not self.amount:  # Check if todate is entered and amount is not provided
    #         self.amount = self.calculate_amount()
    #     super().save(*args, **kwargs)
    # def calculate_amount(self):
    #     duration_days = (self.todate - self.fromdate).days
    #     batchtime_obj=batchtime.objects.get(pk=self.batchid)
    #     pk2=batchtime_obj.id
    #     batch_obj = batch.objects.get(id=pk2)
    #     amount = batch_obj.paymentperday * duration_days
    #     return amount

    def calculate_amount(self):
        duration_days = (self.todate - self.fromdate).days
        batchtime_obj = self.batchid  # Directly access the related batchtime object
        batch_obj = batchtime_obj.batid  # Access the batch from the batchtime object

        amount = batch_obj.paymentperday * duration_days
        return amount

class purpose(models.Model):
    purposeid=models.AutoField(primary_key=True)
    purpose_name=models.CharField(max_length=50)
    payment_perday=models.IntegerField(max_length=50)
    def __str__(self):
        return str(self.purpose_name)
# class groundbooking(models.Model):
#     bookid=models.AutoField(primary_key=True)
#     membid=models.ForeignKey(clubmember,on_delete=models.CASCADE)
#     purpose=models.ForeignKey(purpose,on_delete=models.CASCADE)
#     fromdate=models.DateField()
#     days=models.IntegerField()
#     todate=models.DateField()
#     bookdate=models.DateField()
#     amount=models.IntegerField()
#     bookstatus=models.CharField(default='Pending',max_length=50,)
#     paymentstatus=models.CharField(default='pending',max_length=50)
#     def _str_(self):
#         return str

class groundbooking(models.Model):
    bookid=models.AutoField(primary_key=True)
    membid=models.ForeignKey(clubmember,on_delete=models.CASCADE)
    purpose=models.ForeignKey(purpose,on_delete=models.CASCADE)
    bookdate=models.DateField()
    bookeddate=models.DateField()
    amount=models.IntegerField()
    bookstatus=models.CharField(default='Pending',max_length=50,)
    paymentstatus=models.CharField(default='Complete',max_length=50)
    def _str_(self):
        return str(models.bookid)


class newstb(models.Model):
    newsid = models.AutoField(primary_key=True)
    news = models.TextField(null=False, blank=False )
    date = models.DateField(auto_now_add=True)
    def __str__(self):
        return str(self.newsid)
    def __str__(self):
        return f"ID: {self.newsid}, Date: {self.date}"

