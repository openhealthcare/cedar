"""
Steps for ATLAS
"""
import datetime

from behave import *

from atlas import models

@given('we have saved a subrecord')
def step_impl(context):
    pass

@when('we implement a test')
def step_impl(context):
    assert True is not False

@then('behave will test it for us!')
def step_impl(context):
    assert context.failed is False

@given('we have saved an episode')
def step_impl(context):
    pass


"""
Diagnose Feature
"""
@given('we have a new diagnosis of CAP')
def step_impl(context):
    context.active = False
    if context.sender == models.Diagnosis:
        if context.instance.condition == 'CAP':
            context.active = True


@then('start the patient on Mero')
def step_impl(context):
    if context.active is False:
        return
    treatment = models.Treatment(
        episode=context.instance.episode,
        drug='Meropenem',
        dose='12mg',
        route='IV',
        start_date=datetime.date.today()
    )
    treatment.save()
