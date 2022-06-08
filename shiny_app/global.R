# Library in packages used in this application
library(shiny)
library(DT)
library(RSQLite)
library(DBI)
library(shinyjs)
library(shinydashboard)
library(shinycssloaders)
library(lubridate)
library(shinyFeedback)
library(dplyr)
library(dbplyr)
library(readr)
library(odbc)
library(shinyauthr)
library(shinythemes)
library(shinyWidgets)
library(sqldf)
library(dm)
library(data.table)
library(gdata)
library(RSQLite)
library(zoo)


# ------------------------------------------------------------------------------- #
#Login credentials
#user_base <- readRDS("~/Documents/knw_app/shiny_app/login.RDS")


# ------------------------------------------------------------------------------- #

# database connection 
conn <- DBI::dbConnect(
  RSQLite::SQLite(),
  dbname = '~/Documents/knw_app/shiny_app/database/KNDB.sql'
)

shiny::onStop(function() {
  dbDisconnect(conn)
})

# READ the table 

restable=dbGetQuery(conn, "SELECT * FROM knowTemp ")

# ------------------------------------------------------------------------------- #
# ------------------------------------------------------------------------------ #
# CREATE LIST FOR THE INPUT LIST 

# genes
allgenes <- read.table("datafiles/allgenes.txt",sep = "\t", quote="",header = T)
addGene = list(allgenes$gnlts,restable$Gene)
allgenes = unique(unlist(addGene))

# variants
allvariants <- read.delim("datafiles/allvariants.txt", header=T, quote="") # read.csv("~/Documents/allvariants.txt", sep="") 
#varAll = allvariants[-1,]
addVar = list(allvariants$x,restable$Alteration)
varAll = unique(unlist(addVar))

#type alter
funAlter = c("Missense","NonFrameshift","Splice","FrameShift","Nonsense","Promoter","Insertion","WildType","Oncogenic","Overexpression","Inactivation","Amplification","Loss","Deletion","Duplication","Truncation","Fusion","Inversion","Rearrangement","Downexpress","CNA")

# Associaion
assolist = c("Responsive", "Resistant","No Responsive" ,"Increased Toxicity","Unknown")



# Tumor 
alltumor_type <- read.delim("datafiles/alltumor_type.txt",quote="")


cgi_biomarkers_per_variant <- read_delim("datafiles/cgi_biomarkers_per_variant.tsv",  "\t", escape_double = FALSE, trim_ws = TRUE,show_col_types = FALSE)
# Drug
drg_name <- read.delim("datafiles/drug_name.txt", header=T, quote="")
#drg_name = drg_name[-1,]
addDrugNa = list(drg_name$x,restable$DrugsName)
drg_name = unique(unlist(addDrugNa))

# Drug Full Name
drugfulName = unique(cgi_biomarkers_per_variant$`Drug full name`)
adddrugFull = list(drugfulName,restable$DrugFullName)
drugfulName = unique(unlist(adddrugFull))

# Drug Family
drugfam = unique(cgi_biomarkers_per_variant$`Drug family`)
drugfam = gsub("\\[|\\]", '',drugfam)
addDrugFam = list(drugfam,restable$DrugFamily)
drugfam = unique(unlist(addDrugFam))

# Drug Status
drugstatus = c("Unknown","Approved","FDA Approved","Clinical Trail","Pre-clinical Trail")


# Evidence 
eveidencelevl= c("Case report","Pre-clinical","Early trials","Late trials","Clinical trials","CPIC guidelines","European LeukemiaNet guidelines",
                 "NCCN/CAP guidelines","NCCN guidelines","FDA guidelines","Unknown")



# Turn off scientific notation
options(scipen = 999)

# Set spinner type (for loading)
options(spinner.type = 8)

# Create 'names_map' dataframe to convert variable names ('names') to clean
# column names ('display_names') in table (i.e. capitalized words, spaces, etc.)
#'created_at', 'created_by', 'modified_at', 'modified_by'
#''Created At', 'Created By', 'Modified At', 'Modified By'
names_map <- data.frame(
  names = c("EntryID","Gene", "Alteration","AlterationType", "Association", "TumorType" ,"TumorAcroym","TumorGroup",
            "Target", "Reference1","DrugsName","DrugFullName", "DrugFamily","DrugStatus","DrugEvidence","NotesInfo","Curator","Date" ),
           
  display_names = c("EntryID","Genes", "Alteration","Type", "Association", "Tumor" ,"Abberivation","Group","Target", "References",
                    "Drugs Name","Full Name", "Family","Status","Evidence","Notes","Curator","Date"),
  stringsAsFactors = FALSE
)
source("R/table_generate.R")

source("R/value_delete.R")
