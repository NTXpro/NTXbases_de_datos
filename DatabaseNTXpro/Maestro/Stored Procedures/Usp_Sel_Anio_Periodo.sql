CREATE PROC [Maestro].[Usp_Sel_Anio_Periodo]

AS

BEGIN
declare @ano_actual int  = (select datepart(year,getdate()))

declare @ano_limite int =(select datepart(year,getdate())-5)


SELECT DISTINCT A.ID,
A.Nombre 
FROM Maestro.Anio A INNER JOIN ERP.Periodo P
ON A.ID = P.IdAnio
where A.Nombre <= @ano_actual and A.Nombre>@ano_limite
ORDER BY A.Nombre

END