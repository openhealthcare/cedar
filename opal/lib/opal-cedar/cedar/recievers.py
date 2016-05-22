"""
Define the OPAL signal receivers we will hook into to fire our activities
"""
from opal.core.signals import worker

from cedar import runner

def receiver(what):
    """
    Factory function that returns a receiver for WHAT
    """
    def the_receiver(sender, created=None, instance=None, **kw):
        """
        Generated receiver function that will kick of the Behave
        Runner.
        """
        def add_context(context):
            """
            Generated Behave environment hook to pass our Django signal
            variables into the Feature environment
            """
            context.sender = sender
            context.created = created
            context.instance = instance
            return

        hooks = [add_context]
        cedarrunner = runner.get_runner(tags=[what], before_all_hooks=hooks)
        cedarrunner.run()
        return
    return the_receiver

episode_receiver = receiver('episode')
patient_receiver = receiver('patient')
subrecord_receiver = receiver('subrecord')

worker.patient_post_save.connect(patient_receiver, dispatch_uid='cedar.patient.post_save')
worker.episode_post_save.connect(episode_receiver, dispatch_uid='cedar.episode.post_save')
worker.subrecord_post_save.connect(subrecord_receiver, dispatch_uid='cedar.subrecord.post_save')
