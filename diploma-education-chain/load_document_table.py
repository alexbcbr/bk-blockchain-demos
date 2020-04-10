#!/usr/bin/env python3

from boto3 import client
from pyqldb.driver.pooled_qldb_driver import PooledQldbDriver #pip install pyqldb==1.0.0rc2

from data.constants import Constants
from data.sampledata import SampleData
import util.ion_conversion as util

from logging import basicConfig, getLogger, INFO

logger = getLogger(__name__)
basicConfig(level=INFO)

def create_table(transaction_executor, table_name):
    logger.info("Creating the '{}' table...".format(table_name))
    statement = 'CREATE TABLE {}'.format(table_name)
    cursor = transaction_executor.execute_statement(statement)
    logger.info('{} table created successfully.'.format(table_name))
    return len(list(cursor))

def create_index(transaction_executor, table_name, index_attribute):
    logger.info("Creating index on '{}'...".format(index_attribute))
    statement = 'CREATE INDEX on {} ({})'.format(table_name, index_attribute)
    cursor = transaction_executor.execute_statement(statement)
    return len(list(cursor))

def insert_documents(transaction_executor, table_name, documents):
    logger.info('Inserting some documents in the {} table...'.format(table_name))
    statement = 'INSERT INTO {} ?'.format(table_name)
    cursor = transaction_executor.execute_statement(statement, [util.convert_object_to_ion(documents)])

def insert_documents_batch(transaction_executor):
    insert_documents(transaction_executor, Constants.STUDENTS_NAME_TABLE_NAME, SampleData.STUDENTS)
    insert_documents(transaction_executor, Constants.STUDENTS_EXAM_SCORE_TABLE_NAME, SampleData.SCORE)

if __name__ == '__main__':

    qldb_driver = PooledQldbDriver(ledger_name=Constants.LEDGER_NAME)

    try:
        with qldb_driver.get_session() as session:
            session.execute_lambda(lambda x: 
                                   create_table(x, Constants.STUDENTS_NAME_TABLE_NAME) and
                                   create_table(x, Constants.STUDENTS_EXAM_SCORE_TABLE_NAME),
                                   lambda retry_attempt: logger.info('Retrying due to OCC conflict...'))

            input("Tables created successfully. Press <ENTER> to create index\n")
            
            session.execute_lambda(lambda x: 
                                   create_index(x, Constants.STUDENTS_NAME_TABLE_NAME,
                                                   Constants.STUDENT_ID_INDEX_NAME) and

                                   create_index(x, Constants.STUDENTS_EXAM_SCORE_TABLE_NAME,
                                                   Constants.STUDENTS_EXAM_SCORE_INDEX_NAME),
                                   lambda retry_attempt: logger.info('Retrying due to OCC conflict...'))

            input("Indexes created successfully. Press <ENTER> to load sample data\n")

            session.execute_lambda(lambda executor: insert_documents_batch(executor),
                                   lambda retry_attempt: logger.info('Retrying due to OCC conflict...'))

            logger.info('Documents inserted successfully!')
    
    except Exception:
        print("Error trying to connect QLDB")
        logger.exception('Errors creating tables.')