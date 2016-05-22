Feature: Administer Drugs

  @subrecord
  Scenario: Diagnosed with CAP
     Given we have a new diagnosis of CAP
     Then start the patient on Mero
