"""
Utility functions for CEDAR
"""
from django.apps import apps
import ffs

def app_subdirs(subdir):
    """
    Given the name of a SUBDIR as a string, return an iterable
    of directory Paths for that SUBDIR inside each INSTALLED_APP
    which actually exist on our filesystem.
    """
    for app in apps.get_app_configs():
        subpath = ffs.Path(app.path) / subdir
        if subpath:
            yield subpath
