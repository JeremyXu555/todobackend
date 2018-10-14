from rest_framework import status
from rest_framework import viewsets
from rest_framework.response import Response
from rest_framework.reverse import reverse

from todo.models import TodoItem
from todo.serializers import TodoItemSerializer


class TodoItemViewSet(viewsets.ModelViewSet):
  queryset = TodoItem.objects.all()
  serializer_class = TodoItemSerializer

  def perform_create(self, serializer):
    # Save instance to get primary key and then update URL
    instance = serializer.save()
    # http://<fqdn>:<port>/todos/<primary key>
    # e.g. http://localhost:8000/todos/18
    instance.url = reverse('todoitem-detail', args=[instance.pk], request=self.request)
    instance.save()

  # Deletes all todo items
  def delete(self, request):
    TodoItem.objects.all().delete()
    return Response(status=status.HTTP_204_NO_CONTENT)