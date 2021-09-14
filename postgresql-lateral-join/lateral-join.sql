select cl.i_customer,       
       cl_last_month.first_login as last_month_first_login,
       cl_last_month.last_login  as last_month_last_login
from customer_logins cl         
         left join lateral (select min(cl1.created_at) as first_login,
                                   max(cl1.created_at) as last_login
                            from customer_logins cl1                                     
                            where cl1.i_costumer = cl.i_costumer                              
                              -- date_trunc help us to garantee that will be 
                              -- comparing with the last month
                              and date_trunc('month', cl1.created_at) =
                                  date_trunc('month', cl.created_at - interval '1 month')) as cl_last_month
                    -- as we made our reference criteria inside the sub-select query
                    -- we can just use "on true" to return all the records
                   on true