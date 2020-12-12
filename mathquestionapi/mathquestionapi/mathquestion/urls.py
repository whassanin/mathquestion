from django.urls import path
from rest_framework.urlpatterns import format_suffix_patterns
from . import views

urlpatterns = [

    # basic data
    path('mathdata/', views.MathDataList.as_view()),
    path('mathdata/<int:pk>', views.MathDataDetail.as_view()),

]

urlpatterns = format_suffix_patterns(urlpatterns)