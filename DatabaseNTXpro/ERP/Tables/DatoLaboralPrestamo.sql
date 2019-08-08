CREATE TABLE [ERP].[DatoLaboralPrestamo] (
    [ID]             INT             IDENTITY (1, 1) NOT NULL,
    [IdDatoLaboral]  INT             NULL,
    [IdConcepto]     INT             NULL,
    [IdEmpresa]      INT             NULL,
    [Monto]          DECIMAL (14, 5) NULL,
    [Cuotas]         DECIMAL (14, 5) NULL,
    [Descuento]      DECIMAL (14, 5) NULL,
    [FechaPrestamo]  DATETIME        NULL,
    [FechaDescuento] DATETIME        NULL,
    [FlagCancelado]  BIT             NULL,
    CONSTRAINT [PK__Prestamo__3214EC27E4D7C622] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__Prestamo__IdConc__51B19347] FOREIGN KEY ([IdConcepto]) REFERENCES [ERP].[Concepto] ([ID]),
    CONSTRAINT [FK__Prestamo__IdDato__50BD6F0E] FOREIGN KEY ([IdDatoLaboral]) REFERENCES [ERP].[DatoLaboral] ([ID]),
    CONSTRAINT [FK__Prestamo__IdEmpr__52A5B780] FOREIGN KEY ([IdEmpresa]) REFERENCES [ERP].[Empresa] ([ID])
);

