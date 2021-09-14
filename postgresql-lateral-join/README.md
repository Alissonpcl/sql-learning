# LATERAL Join

## About

"The LATERAL key word can precede a sub-SELECT FROM item. This allows the sub-SELECT to refer to columns of FROM items that appear before it in the FROM list. (Without LATERAL, each sub-SELECT is evaluated independently and so cannot cross-reference any other FROM item.)"

....

"When a FROM item contains LATERAL cross-references, evaluation proceeds as follows: for each row of the FROM item providing the cross-referenced column(s), or set of rows of multiple FROM items providing the columns, the LATERAL item is evaluated using that row or row set's values of the columns. The resulting row(s) are joined as usual with the rows they were computed from. This is repeated for each row or set of rows from the column source table(s)."

**Reference:** [PostgreSQL 9.3 Docs](https://www.postgresql.org/docs/9.3/sql-select.html#SQL-FROM)


## My Uses Cases

In my experience Lateral Joins are helpful when we need to make a sub-select query that must bring more than just one column. The normal way to accomplish that is to duplicate the sub-query returning each column. With LATERAL, it is possible to accomplish it in an easier and less expensive way with a sub-query that will bring all the columns we need.