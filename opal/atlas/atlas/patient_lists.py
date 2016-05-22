"""
Defining OPAL PatientLists
"""
from opal import core
from opal.models import Episode

from atlas import models

class AllPatientsList(core.patient_lists.PatientList):
    display_name = 'All Patients'

    schema = [
        models.Demographics,
        models.Diagnosis,
        models.Treatment
    ]

    def get_queryset(self):
        return Episode.objects.all()