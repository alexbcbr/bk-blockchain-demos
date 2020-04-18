import unittest

from pyqldb.driver.pooled_qldb_driver import PooledQldbDriver
from amazon.ion.simpleion import dumps

class TestLedger(unittest.TestCase):

    def test_init(self):
        self.assertEqual(1, 1)

    def test_connection(self):
        LEDGER_NAME = "health-wallet-ledger"
        qldb_driver = PooledQldbDriver(ledger_name=LEDGER_NAME)
        tables = qldb_driver.get_session().list_tables()
        print(tables)
        self.assertTrue(tables)

if __name__ == '__main__':
    unittest.main()