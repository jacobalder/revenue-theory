################################################################################
# F609, Dr. Denvil Duncan
# Date: 1/26/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: main.R
# Outputs: 
# Purpose: Revenue Forecasting Assignment for State of Indiana
################################################################################
# Subset tax data
year.min = 2000
year.max = 2021
tax.sub = tax[FY>=year.min & FY<=year.max,]
y.axis = seq(round(min(tax.sub$IITax_Rev)-6,-1),
             round(max(tax.sub$IITax_Rev)+1,-1),100)
x.axis = seq(year.min,year.max,2)

(plot = ggplot(data=tax.sub,aes(x = FY, y = IITax_Rev)) +
    geom_boxplot(aes(group=FY),outlier.shape = NA) +
    geom_smooth(method = lm, formula = y ~ splines::bs(x, 3), se = FALSE) + 
    labs(x = "Fiscal Year",    y = "Individual Income Tax [$ Millions]",
         title = paste0("Individual Income Tax Revenue ",year.min," - ",year.max),
         subtitle = "Indiana Historical Data, fitted",
         caption = "Source: Indiana SBA",
    ) +
    scale_x_continuous(breaks = x.axis) +
    scale_y_continuous(breaks = y.axis) +
    theme_classic()
)
ggsave(paste0("figures/iitr",year.min,"-",year.max,".png"),plot,"png")

# Predict Values
rindtax = feols(IITax_Rev ~ Qtr + splines::bs(FY,3),data=tax.sub, vcov = "HC1")
summary(rindtax)
new <- data.frame(Qtr=c(3,4,1,2,3,4),
                  FY=c(2022,2022,2023,2023,2023,2023))

#use the fitted model to predict the value for the new observation
ii_tax_predict = predict(rindtax, newdata = new)

# feols(IITax_Rev ~ i(FY,Qtr) + FY + Qtr,data=tax.sub, vcov = "HC1")
# feols(IITax_Rev ~ i(FY) | Qtr,data=tax.sub, vcov = "HC1")
# feols(IITax_Rev ~ FY + i(CY) + i(Qtr),data=tax.sub, vcov = "HC1")
# feols(IITax_Rev ~ Qtr, data = tax.sub, vcov = "HC1")
# feols(IITax_Rev ~ Qtr + FY, data = tax.sub, vcov = "HC1")
# feols(Sales_Tax_Rev~FY+Qtr, data=tax.sub)

# Come back to this
# https://www.simplilearn.com/tutorials/data-science-tutorial/time-series-forecasting-in-r
# auto.arima(cit)
# tsdata <- ts(cit, frequency = 12) 
# ddata <- decompose(tsdata, "multiplicative")
# plot(ddata)


# Sales -------------------------------------------------------------------

year.min = 2000
year.max = 2021
tax.sub = tax[FY>=year.min & FY<=year.max,]
y.axis = seq(round(min(tax.sub$Sales_Tax_Rev)-6,-1),
             round(max(tax.sub$Sales_Tax_Rev)+1,-1),100)
x.axis = seq(year.min,year.max,2)

(plot = ggplot(data=tax.sub,aes(x = FY, y = Sales_Tax_Rev)) +
    geom_boxplot(aes(group=FY),outlier.shape = NA) +
    geom_smooth(method = lm, formula = y ~ splines::bs(x, 3), se = FALSE,color = "red") + 
    labs(x = "Fiscal Year",    y = "Sales Tax [$ Millions]",
         title = paste0("Sales Tax Revenue ",year.min," - ",year.max),
         subtitle = "Indiana Historical Data, fitted",
         caption = "Source: Indiana SBA",
    ) +
    scale_x_continuous(breaks = x.axis) +
    scale_y_continuous(breaks = y.axis) +
    theme_classic()
)
ggsave(paste0("figures/str",year.min,"-",year.max,".png"),plot,"png")

reg.str = feols(Sales_Tax_Rev ~ Qtr + splines::bs(FY,3),data=tax.sub, vcov = "HC1")
summary(reg.str)
sales_tax_predict = predict(reg.str, newdata = new)

## Model Summary
models = list(rindtax,reg.str)
modelsummary(models,output = "figures/models.tex")

predictions = as.data.frame(cbind(new,ii_tax_predict,sales_tax_predict))
write.csv(predictions,"data/predictions.csv")

# Clean up
rm(list=setdiff(ls(),c("predictions")))
