from datetime import datetime

class SampleData:
    """
    Sample domain objects
    """
    PATIENTS = [
        {
            'FirstName': 'Raul',
            'LastName': 'Lewis',
            'Address': '1719 University Street, Seattle, WA, 98109',
            'DOB': datetime(1963, 8, 19),
            'GovID': 'LEWISR261LL',
            'GovIDType': 'Driver License'
        },
        {
            'FirstName': 'Brent',
            'LastName': 'Logan',
            'DOB': datetime(1967, 7, 3),
            'Address': '43 Stockert Hollow Road, Everett, WA, 98203',
            'GovID': 'LOGANB486CG',
            'GovIDType': 'Driver License'
        },
        {
            'FirstName': 'Alexis',
            'LastName': 'Pena',
            'DOB': datetime(1974, 2, 10),
            'Address': '4058 Melrose Street, Spokane Valley, WA, 99206',
            'GovID': '744 849 301',
            'GovIDType': 'SSN'
        }
    ]
    BREAST = [
        {
            'GovID': '744 849 301',
            'menopause': 'premeno',
            'tumor-size': '15-19',
            'inv-nodes': 90,
            'node-caps': 'yes',
            'deg-malig': '3',
            'breast': 'right',
            'breast-quad': 'left_up',
            'irradiat': 'left_up'
        }
    ]