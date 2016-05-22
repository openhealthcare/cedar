from django.core.management.base import BaseCommand

from cedar.runner import get_runner

class Command(BaseCommand):
    def handle(self, *args, **k):
        def hook(context):
            context.step_id = "1"
            from mock import MagicMock
            context.instance = MagicMock()
            context.sender = MagicMock()
            pass

        cedarrunner = get_runner(before_all_hooks=[hook])
        cedarrunner.run()
