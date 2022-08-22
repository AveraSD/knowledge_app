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
library(here)
library(config)
library(sodium)



# dataframe that holds usernames, passwords and other user data
user_base <- readRDS("user_base.rds")

# ------------------------------------------------------------------------------- #
#Login credentials
#user_base <- readRDS("~/Documents/knw_app/shiny_app/login.RDS")


# ------------------------------------------------------------------------------- #

data_path <- config::get("data_path") %>% here()
file_path <- config::get("file_path") %>% here()
dtname = config::get("db")$dbname


# database connection 
conn <- DBI::dbConnect(
  RSQLite::SQLite(),
  dbname <- data_path
)

shiny::onStop(function() {
  dbDisconnect(conn)
})

# READ the table 

#restable=dbGetQuery(conn, "SELECT * FROM knowTemp ")
#print(restable)
# ------------------------------------------------------------------------------- #
# ------------------------------------------------------------------------------ #

# CREATE LIST FOR THE INPUT VARIABLES


# genes
allgeneR <- paste0(file_path,"allgenes.txt")

allgenes <- read.table(file = allgeneR, 
                       header = TRUE, 
                       sep="\t", 
                       quote = "", 
                       na.strings = 'NA') %>% distinct()




#addGene = list(allgenes$gnlts,restable$Gene)
allgenes = unique(unlist(allgenes$gnlts))


# variants

allvarR <- paste0(file_path,"allvariants.txt")
allvariants <- read.delim(allvarR, 
                          header=T,
                          sep = "\t",
                          na.strings = 'NA',
                          quote="") %>% distinct() # read.csv("~/Documents/allvariants.txt", sep="") 
#varAll = allvariants[-1,]
#addVar = list(allvariants$x,restable$Alteration)
varAll = unique(unlist(allvariants$x))

#type alter
funAlter = c("Missense","NonFrameshift","Splice","FrameShift","Nonsense","Promoter","Insertion","WildType","Oncogenic","Overexpression","Inactivation","Amplification","Loss","Deletion",
             "Duplication","Truncation","Fusion","Inversion","Rearrangement","Downexpress",
             "CNA","Positive","Negative")

# Associaion
assolist = c("Responsive", "Resistant","No Responsive" ,"Increased Toxicity","Unknown")



# Tumor 
alltumorR <- paste0(file_path,"alltumor_type.txt")

alltumor_type <- read.delim(alltumorR,
                            quote="",
                            header=T,
                            sep = "\t",
                            na.strings = 'NA'
)
alltumor_type$Tumor <- trimws(alltumor_type$Tumor)
# Tumor group 
tgrp = c("Primary","Metastatic","Adjuvant","Neo-Adjuvant")

# Target 
targ = c("Direct","Indirect","Unknown")

#

cgi_biomarkers_per_variant <- read_delim("datafiles/cgi_biomarkers_per_variant.tsv",  "\t", escape_double = FALSE, trim_ws = TRUE,show_col_types = FALSE)
# Drug
alldrug = paste0(file_path,"drug_name.txt")
drg_name <- read.delim(alldrug, header=T,
                       quote="",
                       sep = "\t",
                       na.strings = 'NA')
#drg_name = drg_name[-1,]
#addDrugNa = list(drg_name$x,restable$DrugsName)
drg_name = unique(unlist(drg_name$x))

# Drug Full Name
alldFull = paste0(file_path,"drug_fullname.txt")
drugfulName <- read.delim(alldFull, header=T,
                          quote="",
                          sep = "\t",
                          na.strings = 'NA')

drugfulName = unique(unlist(drugfulName$x))

#adddrugFull = list(drugfulName,restable$DrugFullName)


# Drug Family

alldFam = paste0(file_path,"drug_familynames.txt")
drugfam <- read.delim(alldFam , header=T,
                      quote="",
                      sep = "\t",
                      na.strings = 'NA')

drugfam = unique(unlist(drugfam$x))

#drugfam = gsub("\\[|\\]", '',drugfam)


# Drug Status
drugstatus = c("Unknown","Approved","FDA Approved","Clinical Trail","Pre-clinical Trail","Experimental")


# Evidence 
eveidencelevl= c("Case report","Pre-clinical","Early trials","Late trials","Clinical trials","CPIC guidelines","European LeukemiaNet guidelines",
                 "NCCN/CAP guidelines","NCCN guidelines","FDA guidelines","Unknown")



# usrs 
people = c("Bing","Karla","Priya","Rosie","Shivani","Tobias","Yuliang","CGI")

# Turn off scientific notation
options(scipen = 999)

# Set spinner type (for loading)
options(spinner.type = 8)


names_map <- data.frame(
  names = c("EntryID","Gene", "Alteration","AlterationType", "Association", "TumorType" ,"TumorAcroym","TumorGroup",
            "Target", "Reference1","DrugsName","DrugFullName", "DrugFamily","DrugStatus","DrugEvidence","NotesInfo","Curator","Date" ),
  
  display_names = c("EntryID","Genes", "Alteration","Type", "Association", "Tumor" ,"Abberivation","Group","Target", "References",
                    "Drugs Name","Full Name", "Family","Status","Evidence","Notes","Editor","Date"),
  stringsAsFactors = FALSE
)

rectdf = reactiveValues(
  foradEd = tibble()
)
source("R/table_generate.R")

source("R/value_delete.R")
source("R/add_edit.R")
