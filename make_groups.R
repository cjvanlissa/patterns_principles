tmp <- readLines("groups.txt")
tmp <- tmp[grepl("\\d+", tmp)]
studs <- readxl::read_xlsx("students.xlsx", skip = 1)
#  read.csv("2026-09-28T0852_Grades-499115-B-6.csv", stringsAsFactors = F)
all(tmp %in% studs$Studentnummer)
# tmp[!tmp %in% studs$Studentnummer]

# unmatched <- studs$Studentnummer[-which(studs$Studentnummer %in% tmp)]
# unmatched <- unmatched[!is.na(unmatched)]
# cat(sample(unmatched), sep = "\n")

# stringdist::amatch("nr", as.character(studs$SIS.User.ID))

tmp <- readLines("groups.txt")
groups <- lapply(seq(1, length(tmp), by = 7), function(i){
  list(
    name = tmp[i+1],
    major = tmp[i],
    students = data.frame(ID = tmp[(i+2):(i+5)], email = studs$`E-mail adres`[match(tmp[(i+2):(i+5)], studs$Studentnummer)])
  )
})

