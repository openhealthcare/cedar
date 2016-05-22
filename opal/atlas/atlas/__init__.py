"""
atlas - Our OPAL Application
"""
from opal.core import application
from opal.core import celery

class Application(application.OpalApplication):
    schema_module = 'atlas.schema'
    flow_module   = 'atlas.flow'
    javascripts   = [
        'js/atlas/routes.js',
        'js/opal/controllers/discharge.js'
    ]
