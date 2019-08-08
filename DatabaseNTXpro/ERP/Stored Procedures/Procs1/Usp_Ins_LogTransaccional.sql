-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 14/09/2018
-- Description:	INSERTAR VALORES EN LA TABLA TRANSACCIONAL
-- =============================================
CREATE PROCEDURE ERP.Usp_Ins_LogTransaccional
	-- Add the parameters for the stored procedure here
	@TIPO INT,
    @MODULO VARCHAR(250),
    @PROCESO VARCHAR(250),
    @DESCRIPCION NVARCHAR(1024),
    @USUARIO VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   
INSERT ERP.LogTransaccional
(
    --ID - this column value is auto-generated
    tipo,
    Modulo,
    Proceso,
    Descripcion,
    usuario,
    fecha
)
VALUES
(
    -- ID - int
    @TIPO, -- tipo - int
    @MODULO, -- Modulo - varchar
    @PROCESO, -- Proceso - varchar
    @DESCRIPCION, -- Descripcion - nvarchar
    @USUARIO, -- usuario - varchar
    GETDATE()
)
END