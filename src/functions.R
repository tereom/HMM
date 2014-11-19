
# Create polynomial of degree d
createPoly <- function(x, y, d){ # d: degree
  a <- model.matrix(~ poly(x, d, raw = T) * poly(y, d, raw = T))
  a.1 <- sapply(1:ncol(a), function(i){
    as.numeric(substr(colnames(a)[i], 20, 20)) +
      as.numeric(substr(colnames(a)[i], 41, 41))})
  a.sub <- a[, is.na(a.1) | (a.1 < d + 1)]
  a.sub[, -1]
}