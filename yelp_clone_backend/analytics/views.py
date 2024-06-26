
from django.shortcuts import render
from django.db.models import Count
from .models import BusinessView, ProductSearch, ServiceSearch, ContentEngagement
from django.contrib.auth.decorators import login_required
from django.contrib.admin.views.decorators import staff_member_required

@login_required
@staff_member_required
def dashboard(request):
    business_views = BusinessView.objects.values('business__name').annotate(view_count=Count('id')).order_by('-view_count')
    product_searches = ProductSearch.objects.values('product__name').annotate(search_count=Count('id')).order_by('-search_count')
    service_searches = ServiceSearch.objects.values('service__name').annotate(search_count=Count('id')).order_by('-search_count')
    content_engagements = ContentEngagement.objects.values('content_type', 'content_id', 'action').annotate(action_count=Count('id')).order_by('-action_count')

    context = {
        'business_views': business_views,
        'product_searches': product_searches,
        'service_searches': service_searches,
        'content_engagements': content_engagements,
    }
    return render(request, 'analytics/dashboard.html', context)
