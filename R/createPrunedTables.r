#' @title Create pruned CDM and Vocab tables.
#'
#' @description This function creates the pruned cdm and vocab tables by keeping only those rows from
#'              the original tables for given concept_ids. (Eunomia support)
#'
#' @usage createPrunedTables(connectionDetails,cdmSchema,eventConceptId,cdmVersion)
#'
#' @param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#'
#' @param cdmDatabaseSchema  The name of the database schema that contains the CDM.
#'                           Requires read and write permissions to this database. On SQL
#'                           Server, this should specifiy both the database and the schema,
#'                           so for example 'cdm_instance.dbo'.
#' @param eventConceptId      A vector of concept_ids returned from \code{getEventConceptId}.
#' @param cdmVersion The version of your CDM.  Currently "5.3" and "6.0".
#'
#'@export


createPrunedTables <- function (connectionDetails, cdmSchema, eventConceptId,cdmVersion)
{
	if (cdmVersion == "5.3")
		sqlFilePath <- "v53"
	else if (cdmVersion == "6.0")
		sqlFilePath <- "v60"

	sql <- SqlRender::loadRenderTranslateSql(
			sqlFileName = paste0(sqlFilePath,"/create_pruned_tables.sql"),
			packageName = "ETLSyntheaBuilder",
			dbms        = connectionDetails$dbms,
			cdm_schema = cdmDatabaseSchema,
			event_concept_id = eventConceptId
			)

	conn <- DatabaseConnector::connect(connectionDetails)

	DatabaseConnector::executeSql(conn,sql)

	on.exit(DatabaseConnector::disconnect(conn))
}
