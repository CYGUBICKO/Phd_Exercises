A single object matching ‘resamples.default’ was found
It was found in the following places
  registered S3 method for resamples from namespace caret
  namespace:caret
with value

function (x, modelNames = names(x), ...) 
{
    if (length(x) < 2) 
        stop("at least two train objects are needed")
    classes <- unlist(lapply(x, function(x) class(x)[1]))
    if (is.null(modelNames)) {
        modelNames <- well_numbered("Model", length(x))
    }
    else {
        if (any(modelNames == "")) {
            no_name <- which(modelNames == "")
            modelNames[no_name] <- well_numbered("Model", length(x))[no_name]
        }
    }
    numResamp <- unlist(lapply(x, function(x) length(x$control$index)))
    if (length(unique(numResamp)) > 1) 
        stop("There are different numbers of resamples in each model")
    for (i in 1:numResamp[1]) {
        indices <- lapply(x, function(x, i) sort(x$control$index[[1]]), 
            i = i)
        uniqueIndex <- length(table(table(unlist(indices))))
        if (length(uniqueIndex) > 1) 
            stop("The samples indices are not equal across resamples")
    }
    getTimes <- function(x) {
        out <- rep(NA, 3)
        if (all(names(x) != "times")) 
            return(out)
        if (any(names(x$times) == "everything")) 
            out[1] <- x$times$everything[3]
        if (any(names(x$times) == "final")) 
            out[2] <- x$times$final[3]
        if (any(names(x$times) == "prediction")) 
            out[3] <- x$times$prediction[3]
        out
    }
    rs_values <- vector(mode = "list", length = length(x))
    for (i in seq(along = x)) {
        if (class(x[[i]])[1] == "rfe" && x[[i]]$control$returnResamp == 
            "all") {
            warning(paste0("'", modelNames[i], "' did not have 'returnResamp=\"final\"; the optimal subset is used"))
        }
        if (class(x[[i]])[1] == "train" && x[[i]]$control$returnResamp == 
            "all") {
            warning(paste0("'", modelNames[i], "' did not have 'returnResamp=\"final\"; the optimal tuning parameters are used"))
        }
        if (class(x[[i]])[1] == "sbf" && x[[i]]$control$returnResamp == 
            "all") {
            warning(paste0("'", modelNames[i], "' did not have 'returnResamp=\"final\"; the optimal subset is used"))
        }
        rs_values[[i]] <- get_resample_perf(x[[i]])
    }
    all_names <- lapply(rs_values, function(x) names(x)[names(x) != 
        "Resample"])
    all_names <- table(unlist(all_names))
    if (length(all_names) == 0 || any(all_names == 0)) {
        warning("Could not find performance measures")
    }
    if (any(all_names < length(x))) {
        warning(paste("Some performance measures were not computed for each model:", 
            paste(names(all_names)[all_names < length(x)], collapse = ", ")))
    }
    pNames <- names(all_names)[all_names == length(x)]
    rs_values <- lapply(rs_values, function(x, n) x[, n, drop = FALSE], 
        n = c(pNames, "Resample"))
    for (mod in seq(along = modelNames)) {
        names(rs_values[[mod]])[names(rs_values[[mod]]) %in% 
            pNames] <- paste(modelNames[mod], names(rs_values[[mod]])[names(rs_values[[mod]]) %in% 
            pNames], sep = "~")
        out <- if (mod == 1) 
            rs_values[[mod]]
        else merge(out, rs_values[[mod]])
    }
    timings <- do.call("rbind", lapply(x, getTimes))
    colnames(timings) <- c("Everything", "FinalModel", "Prediction")
    out <- structure(list(call = match.call(), values = out, 
        models = modelNames, metrics = pNames, timings = as.data.frame(timings), 
        methods = unlist(lapply(x, function(x) x$method))), class = "resamples")
    out
}
<bytecode: 0x16f1b4b8>
<environment: namespace:caret>


get_resample_perf.train <- function(x) {
  if(x$control$returnResamp == "none")
    stop("use returnResamp == 'none' in trainControl()", call. = FALSE)
  out <- merge(x$resample, x$bestTune)
  out[, c(x$perfNames, "Resample")]
}
