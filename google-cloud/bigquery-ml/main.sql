 -- BigQuery ML: Iris Dataset Model Creation
 -- Create bqml_tutorial dataset

 
SELECT

  *

FROM

  `bigquery-public-data.ml_datasets.iris`

-- Create the dataset if it does not exist
CREATE OR REPLACE MODEL

  `bqml_tutorial.irisdata_model`

OPTIONS

  ( model_type='LOGISTIC_REG',

    auto_class_weights=TRUE,

    data_split_method='NO_SPLIT',

    input_label_cols=['species'],

    max_iterations=10) AS

SELECT

  *

FROM

  `bigquery-public-data.ml_datasets.iris`



---  -- Evaluate the model using the same dataset

  SELECT * FROM ML.EVALUATE(MODEL bqml_tutorial.irisdata_model,

   (

SELECT

*

FROM `bigquery-public-data.ml_datasets.iris`))



