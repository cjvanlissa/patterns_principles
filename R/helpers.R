make_table <- function(x, dt_options = list(options = list(pageLength = nrow(x)), autoHideNavigation = TRUE, rownames = FALSE),
                       kable_args = list()){
  out = ""
  if (knitr::is_html_output()) {
    tbl <- do.call(
      DT::datatable,
      c(list(data = x), dt_options)
    )
    print(tbl)
    return(tbl)
  }

  if (knitr::is_latex_output()) {
    tbl <- do.call(
      kableExtra::kbl,
      c(
        list(x = x),
        kable_args
      )
    )
    # nc <- max(sapply(strsplit(as.character(tbl), split = "\\", fixed = TRUE)[[1]], nchar))
    # if(nc > 150){
    #   tbl <- do.call(
    #     kableExtra::kbl,
    #     c(
    #       list(x = x, latex_options = "scale_down"),
    #       kable_args
    #     )
    #   )
    # }
    return(tbl)
    #return(knitr::asis_output(paste0("\n\n", tbl, "\n\n")))
  }
  return(out)

}
