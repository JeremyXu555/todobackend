from django.conf.urls import url, include
# when importing from other files, should start from the app name like todo.views not todobackend.src.todo.views
from django.urls import path
from rest_framework import routers
from todo import views
from rest_framework.routers import DefaultRouter

router = routers.DefaultRouter()
router.register(r'todos', views.TodoItemViewSet)

# The API URLs are now determined automatically by the router.
urlpatterns = [
    path('', include(router.urls)),
]
