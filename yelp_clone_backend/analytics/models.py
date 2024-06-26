
from django.db import models
from businesses.models import Business, Product, Service
from users.models import User

class BusinessView(models.Model):
    business = models.ForeignKey(Business, on_delete=models.CASCADE)
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True)
    timestamp = models.DateTimeField(auto_now_add=True)

class ProductSearch(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True)
    timestamp = models.DateTimeField(auto_now_add=True)

class ServiceSearch(models.Model):
    service = models.ForeignKey(Service, on_delete=models.CASCADE)
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True)
    timestamp = models.DateTimeField(auto_now_add=True)

class ContentEngagement(models.Model):
    content_type = models.CharField(max_length=50)
    content_id = models.IntegerField()
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True)
    action = models.CharField(maxlength=50)
    timestamp = models.DateTimeField(auto_now_add=True)
