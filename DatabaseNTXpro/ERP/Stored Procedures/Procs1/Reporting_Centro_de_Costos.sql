create proc [ERP].[Reporting_Centro_de_Costos]
@IdEmpresa int,
@Año varchar(50),
@MesInicio int,
@MesActual int,
@Proyecto varchar(250)
as
select  
 (PivotTable.Numero+'  '+PivotTable.Nombres) as Nombres ,
 (PivotTable.CuentaContable+'  '+PivotTable.Nombre) as NombreCuenta,
 PivotTable.Anio,
 cast(isnull (PivotTable.[ENERO],0)AS DECIMAL(18,2))  AS [ENERO],
 cast(isnull (PivotTable.[FEBRERO],0)AS DECIMAL(18,2))  AS [FEBRERO],
 cast(isnull (PivotTable.[MARZO],0) AS DECIMAL(18,2)) AS [MARZO],
 cast(isnull (PivotTable.[ABRIL],0) AS DECIMAL(18,2)) AS [ABRIL],
 cast(isnull (PivotTable.[MAYO],0) AS DECIMAL(18,2)) AS [MAYO],
 cast(isnull (PivotTable.[JUNIO],0)AS DECIMAL(18,2))  AS [JUNIO],
 cast(isnull (PivotTable.[JULIO],0) AS DECIMAL(18,2)) AS [JULIO],
 cast(isnull (PivotTable.[AGOSTO],0)  AS DECIMAL(18,2)) AS [AGOSTO],
 cast(isnull (PivotTable.[SETIEMBRE],0) AS DECIMAL(18,2))  AS [SETIEMBRE],
 cast(isnull (PivotTable.[OCTUBRE],0) AS DECIMAL(18,2)) AS [OCTUBRE],
 cast(isnull (PivotTable.[NOVIEMBRE],0) AS DECIMAL(18,2))  AS [NOVIEMBRE],
 cast(isnull (PivotTable.[DICIEMBRE],0) AS DECIMAL(18,2)) AS [DICIEMBRE],
 cast((
 (isnull (PivotTable.[ENERO],0))+(isnull (PivotTable.[FEBRERO],0 ))+
 (isnull (PivotTable.[MARZO],0))+(isnull (PivotTable.[ABRIL],0))+
 (isnull (PivotTable.[MAYO],0))+ (isnull (PivotTable.[JUNIO],0))+
 (isnull (PivotTable.[JULIO],0))+(isnull (PivotTable.[AGOSTO],0))+
 (isnull (PivotTable.[SETIEMBRE],0))+(isnull (PivotTable.[OCTUBRE],0))+
 (isnull (PivotTable.[NOVIEMBRE],0))+(isnull (PivotTable.[DICIEMBRE],0))
 )AS DECIMAL(18,2)) AS TOTAL_GENERAL

from
 (
SELECT P.Numero  ,(P.Nombre) as Nombres , 
       PC.CuentaContable, PC.Nombre, 
       SUM(AD.ImporteSoles) as Monto, 
      (AN.Nombre) as Anio, 
	   (M.Nombre)as Mes   
FROM 

ERP.Asiento A INNER JOIN ERP.AsientoDetalle AD 
ON AD.IdAsiento = A.ID INNER JOIN ERP.PlanCuenta PC 
ON PC.ID = AD.IdPlanCuenta INNER JOIN ERP.Proyecto P 
ON P.ID = AD.IdProyecto INNER JOIN ERP.Periodo PE 
ON PE.ID = A.IdPeriodo INNER JOIN Maestro.Anio AN 
ON AN.ID = PE.IdAnio INNER JOIN Maestro.Mes M 
ON M.ID = PE.IdMes

WHERE A.IdPeriodo IN (129, 130, 131, 132, 133, 134, 135, 136, 137)
AND A.IdEmpresa =@IdEmpresa  
AND AN.Nombre=@Año 
AND (M.valor BETWEEN @MesInicio AND @MesActual)
AND  (@Proyecto = '(TODOS)' OR  P.Nombre=@Proyecto)

GROUP BY P.Numero, P.Nombre, PC.CuentaContable,
         PC.Nombre, AN.Nombre, M.Nombre
)
AS SourceTable PIVOT(sum(Monto) 
   FOR Mes IN([ENERO],[FEBRERO],[MARZO],[ABRIL],
                   [MAYO],[JUNIO],[JULIO],[AGOSTO],
				   [SETIEMBRE],[OCTUBRE],[NOVIEMBRE],[DICIEMBRE])) AS PivotTable