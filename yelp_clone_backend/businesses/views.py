
from django.shortcuts import get_object_or_404
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from .models import Business
from analytics.models import BusinessView

class BusinessDetailView(APIView):
    permission_classes = [IsAuthenticatedOrReadOnly]

    def get(self, request, pk):
        business = get_object_or_404(Business, pk=pk)
        if request.user.is_authenticated:
            BusinessView.objects.create(business=business, user=request.user)
        else:
            BusinessView.objects.create(business=business)
        return Response({'name': business.name, 'category': business.category, 'description': business.description})
