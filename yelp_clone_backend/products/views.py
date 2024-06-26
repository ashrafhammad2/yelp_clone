
from django.shortcuts import get_object_or_404
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from .models import Product
from analytics.models import ProductSearch

class ProductSearchView(APIView):
    permission_classes = [IsAuthenticatedOrReadOnly]

    def get(self, request):
        query = request.query_params.get('query', '')
        products = Product.objects.filter(name__icontains(query))
        if request.user.is_authenticated:
            for product in products:
                ProductSearch.objects.create(product=product, user=request.user)
        else:
            for product in products:
                ProductSearch.objects.create(product=product)
        return Response([{'name': product.name, 'description': product.description} for product in products])
