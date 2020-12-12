from django.shortcuts import render

from mathquestion.models import *
from mathquestion.serializer import *

from rest_framework import generics
from rest_framework.views import APIView
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import pagination

from django_filters import rest_framework as filters

class MathDataList(generics.ListCreateAPIView):
    queryset = MathData.objects.all()
    serializer_class = MathDataSerializer
    filter_backends =[DjangoFilterBackend]
    filterset_fields = ['isCalculated']

class MathDataDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = MathData.objects.all()
    serializer_class = MathDataSerializer