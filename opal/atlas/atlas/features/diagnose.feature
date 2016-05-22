Feature: Administer Drugs

  @subrecord
  Scenario: Diagnosed with CAP
     Given we have a new diagnosis of CAP
      then start the patient on Mero
