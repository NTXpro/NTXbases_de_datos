CREATE PROC ERP.Usp_Sel_Vehiculo
AS
BEGIN

		SELECT VE.ID,
			   CONCAT(VE.Marca,'-',VE.Placa) Nombre
		FROM ERP.Vehiculo VE
		WHERE VE.FlagBorrador = 0 AND VE.Flag = 1 
END
