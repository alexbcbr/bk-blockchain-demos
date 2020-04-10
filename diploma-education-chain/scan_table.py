#!/usr/bin/env python3

from logging import basicConfig, getLogger, INFO
from data.constants import Constants

from pyqldb.driver.pooled_qldb_driver import PooledQldbDriver #pip install pyqldb==1.0.0rc2
from amazon.ion.simpleion import dumps

logger = getLogger(__name__)
basicConfig(level=INFO)

def print_result(cursor):
    """
    Pretty print the result set. Returns the number of documents in the result set.

    :type cursor: :py:class:`pyqldb.cursor.stream_cursor.StreamCursor`/
                  :py:class:`pyqldb.cursor.buffered_cursor.BufferedCursor`
    :param cursor: An instance of the StreamCursor or BufferedCursor class.

    :rtype: int
    :return: Number of documents in the result set.
    """
    result_counter = 0
    for row in cursor:
        # Each row would be in Ion format.
        logger.info(dumps(row, binary=False, indent='  ', omit_version_marker=True))
        result_counter += 1
    return result_counter


def scan_table(transaction_executor, table_name):
    """
    Scan for all the documents in a table.

    :type transaction_executor: :py:class:`pyqldb.session.executor.Executor`
    :param transaction_executor: An Executor object allowing for execution of statements within a transaction.

    :type table_name: str
    :param table_name: The name of the table to operate on.

    :rtype: :py:class:`pyqldb.cursor.stream_cursor.StreamCursor`
    :return: Cursor on the result set of a statement query.
    """
    logger.info('Scanning {}...'.format(table_name))
    query = 'SELECT * FROM {}'.format(table_name)
    return transaction_executor.execute_statement(query)


logger = getLogger(__name__)
basicConfig(level=INFO)

#qldb_client = client('qldb')

if __name__ == '__main__':

    qldb_driver = PooledQldbDriver(ledger_name=Constants.LEDGER_NAME)

    try:
        with qldb_driver.get_session() as session:
            # Scan all the tables and print their documents.
            tables = session.list_tables()
            for table in tables:
                cursor = session.execute_lambda(lambda executor: scan_table(executor, table),
                                                lambda retry_attempt: logger.info('Retrying due to OCC conflict...'))
                logger.info('Scan successful!')
                print_result(cursor)
    except Exception:
        logger.exception('Unable to scan tables.')