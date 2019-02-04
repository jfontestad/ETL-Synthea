#' @title Create Synthea Tables.
#'
#' @description This function creates all Synthea tables. 
#'
#' @usage CreateSyntheaTables(connectionDetails, syntheaDatabaseSchema)
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#' @param syntheaDatabaseSchema  The name of the database schema that will contain the Synthea
#'                                     instance.  Requires read and write permissions to this database. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'cdm_instance.dbo'.
#'
#'@export


CreateSyntheaTables <- function (connectionDetails, syntheaDatabaseSchema)
{


    pathToSql <- base::system.file("sql/sql_server", package = "ETLSyntheaBuilder")

    sqlFile <- base::paste0(pathToSql, "/", "create_synthea_tables.sql")

    sqlQuery <- base::readChar(sqlFile, base::file.info(sqlFile)$size)

    renderedSql <- SqlRender::renderSql(sqlQuery, synthea_schema = syntheaDatabaseSchema)$sql

    translatedSql <- SqlRender::translateSql(renderedSql, targetDialect = connectionDetails$dbms)$sql

    writeLines("Running create_synthea_tables.sql")
	
	conn <- DatabaseConnector::connect(connectionDetails) 
	
    DatabaseConnector::dbExecute(conn, translatedSql, progressBar = TRUE, reportOverallTime = TRUE)

    on.exit(DatabaseConnector::disconnect(conn)) 
	
}