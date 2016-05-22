"""
Custom CEDAR Behave runner.
"""
from behave import configuration, runner, tag_expression

from cedar.utils import app_subdirs


class CEDARRunner(runner.Runner):
    def __init__(self, config, before_all_hooks=[]):
        super(CEDARRunner, self).__init__(config)
        self.external_before_all_hooks = before_all_hooks

    def before_all_default_hook(self, context):
        context.config.setup_logging()
        for hook in self.external_before_all_hooks:
            hook(context)

    def feature_locations(self):
        feature_files = []
        for feature_dir in app_subdirs('features'):
            feature_files += feature_dir.ls('*.feature')
        return feature_files


def get_runner(tags=[], before_all_hooks=[]):
    config = configuration.Configuration()
    config.paths = list(app_subdirs('features'))
    config.format = ['pretty']
    config.tags = tag_expression.TagExpression(tags)
    config.verbose = True
    cedarrunner = CEDARRunner(config, before_all_hooks=before_all_hooks)
    return cedarrunner
