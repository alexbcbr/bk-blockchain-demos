DROP TABLE blood_exam
CREATE TABLE blood_exam
--CREATE INDEX ON blood_exam (GovID)
 
INSERT INTO blood_exam
<< {
    'GovID' : '744 849 301',
    'Age': 34,
    'Results' : {
        'Pregnant' : { 'Date': '10/10/2001' },
        'BodyMass' : [33.6, 31.4],
        'DiastolicBloodPressure': 72,
        'PlasmaGlucoseConcentration': 148
    }
} >>

SELECT * from blood_exam

UPDATE blood_exam AS r
    SET   r.Results.BodyMass = [26.6, 20.1],
          r.Results.DiastolicBloodPressure = 66,
          r.Results.PlasmaGlucoseConcentration = 85
    WHERE r.GovID = '744 849 301'
 
--select * from history(blood_exam)

SELECT data.GovID, data.Results.DiastolicBloodPressure, data.Results.BodyMass
    FROM history(blood_exam)
    WHERE metadata.id = 'EwCOB19rHyn6bQLZ9goCpo'

SELECT data.GovID, data.Results.DiastolicBloodPressure, data.Results.BodyMass
    FROM history(blood_exam)
    WHERE metadata.id = 'EauI5bxMQMMAGNFWWINnpX'