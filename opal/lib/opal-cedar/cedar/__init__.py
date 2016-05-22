"""
Plugin definition for the cedar OPAL plugin
"""
from opal.core import plugins

from cedar import recievers
from cedar.urls import urlpatterns

class CedarPlugin(plugins.OpalPlugin):
    """
    Main entrypoint to expose this plugin to our OPAL application.
    """
    urls = urlpatterns
    javascripts = {
        # Add your javascripts here!
        'opal.cedar': [
            # 'js/cedar/app.js',
            # 'js/cedar/controllers/larry.js',
            # 'js/cedar/services/larry.js',
        ]
    }

    def restricted_teams(self, user):
        """
        Return any restricted teams for particualr users that our
        plugin may define.
        """
        return []

    def list_schemas(self):
        """
        Return any patient list schemas that our plugin may define.
        """
        return {}

    def flows(self):
        """
        Return any custom flows that our plugin may define
        """
        return {}

    def roles(self, user):
        """
        Given a (Django) USER object, return any extra roles defined
        by our plugin.
        """
        return {}


plugins.register(CedarPlugin)
