from django.urls import path
from .import views
from .views import *
from django.conf.urls.static import static
from django.conf import settings
urlpatterns = [
    # path("login/",views.loginview,name="login"),
    path("",views.login_view,name="login"),
    path("loadhome/",views.loadhomeview,name="loadhome"),
    path("adminaddgallarry/",views.addclubgallery,name='addgallary'),
    path("admingallary/",views.adminviewgallary,name='adminviewgallary'),
    path("list/<str:pk>/",views.deleteimage,name='deleteimage'),
    path('adminaddsportsitem/',views.adminaddsportsitem,name='addsportsitem'),
    path("adminaddbatch/",views.adminaddbatch,name='addbatch'),
    path('adminviewbatch/',views.adminlistbatch,name='adminbatchlist'),
    path("list1/<str:pk>/",views.deletebatch,name='deletebatch'),
    path("list1/<str:pk>",views.admineditbatch,name='editbatch'),
    path("adminaddnews/",views.addclubnews,name='addnews'),
    path("adminviewnews/",views.adminviewnews,name='adminnewslist'),
    path("admindeletenews/<str:pk>",views.admindeletenews,name='deletenews'),
    path("adminaddclubprofile/",views.addclubprofile,name='addclubprofile'),
    path("adminviewprofile/", views.adminviewprofile, name='adminviewprofile'),

    path("adminaddbatchtime/",views.adminaddtime,name='adminaddbatchtime'),
    path("adminviewbatchtime1/<str:pk>/<str:pk3>",views.adminviewbatchtime1,name='viewbatchtime'),
    path("get_batch_options/",views.get_batch_options,name='get_batch_options'),
    path("admindeletebatchtime/<str:pk>",views.admindeletebatchtime,name='deletebatchtime'),
    path("editbatchtime/<str:pk>",views.admineditbatchtime,name='editbatchtime'),
    path("adminviewmembers/",views.adminviewmembers,name='listmember'),
    path("adminmemberprofileview/<str:pk>",views.adminviewmemberprofile,name='adminviewmemberprofile'),
    path("adminviewallgroundbooking/",views.adminviewgroundbooking,name='viewgroundbooking'),
    path("adminapprovebooking/<str:pk>",views.adminapprovebooking,name='approvebooking'),
    path("adminrejectbooking/<str:pk>", views.adminrejectbooking, name='rejectbooking'),

    path("adminviewregistredbatchlist/",views.adminviewregistredbatch,name='registerdbatchlist'),
    path("adminaddbookingpurpose/",views.adminaddpurpose,name='addpurpose'),
    path("adminviewbookingpurpose/", views.adminviewbookingpurpose, name='viewpurpose'),
    path("admindeletepurpose/<str:pk>",views.admindeletepurpose,name='deletepurpose'),
    path("admineditpurpose/<str:pk>",views.admineditpurpose,name='editpurpose'),
    path('addgroundbooking/', groundbookingcreateview.as_view(), name=''),
    path('adminviewsportsitem/',views.adminviewsportsitem, name='viewsportsitem'),
    path('admineditsportsitem/<str:pk>',views.admineditsportsitem,name='editsportsitem'),
    path('admindeletesportsitem/<str:pk>',views.admindeletesportsitem,name='deletesportsitem'),
    path('viewpayment',views.viewpaymentdetails,name='viewpayment'),
    path('loadindex/',views.loadindex,name='loadindexpage'),
    path('logout/',views.logout_admin,name='logout'),
    path('apiclubmember',AddClubmemberAPI.as_view(),name=''),
    path('apiuserlogin',UserLoginapi.as_view(),name='apiuserlogin'),
    path('apiclubgallary',ClubGalleryView.as_view(),name=""),
    path('apinewsview',NewsView.as_view(),name=""),
    path('apiviewpurpose',purposeview.as_view(),name=""),
    path('apiviewbookeddate',groundbookingdateview.as_view(),name=""),
    path('apigroundbooking',GroundbookingAPI.as_view(),name=""),
    path('apisportsitemview',Sportsitemview.as_view(),name=""),
    path('apibatchview/<str:pk>',Batchview.as_view(),name=""),
    path('apibatchtimeview/<str:pk>',Batchtimeview.as_view(),name=""),
    path('apiusergroundbookaccountview/<str:pk>',Accountview.as_view(),name=''),
    path('apiusergroundbookingpayment/<str:pk>/<int:amount>',GroundBookingPaymentView.as_view(),name=''),
    path('apiusergroundbookingview/<str:pk>',GroundBookingList.as_view(),name=''),
    path('apiuserregisterbatch',BatchregisterAPI.as_view(),name=""),
    path('apiUserBatchregisterview/<str:pk>',UserBatchregisterview.as_view(),name=""),
    path('apimemberviewprofile/<str:pk>',Viewmemberprofile.as_view(),name=""),
    path('apimemeberprofileupdate/<str:pk>',UpdateMemberProfile.as_view(),name=""),

    path('forgotpassword/', ForgotPasswordAPIView.as_view(), name='api-forgotpassword'),
    path('changepassword/',PasswordChangeAPIView.as_view(), name='changepassword'),
    path('apiclubprofileview/',Clubprofilehelp.as_view(),name=""),

    ]

if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
