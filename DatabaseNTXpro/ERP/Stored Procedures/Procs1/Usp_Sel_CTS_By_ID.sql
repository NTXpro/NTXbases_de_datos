CREATE PROC ERP.Usp_Sel_CTS_By_ID
@ID INT
AS
BEGIN
	SELECT ID
      ,FechaInicio
      ,FechaFin
  FROM ERP.CTS
  where ID = @ID
END
