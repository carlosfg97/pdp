use DATALAB

drop table ventas2017
select PKEbelista, AnioCampana,  
sum([RealUUVendidas]) as RealUUVendidas,
sum([RealUUFaltantes]) as RealUUFaltantes,
sum([RealUUDevueltas]) as [RealUUDevueltas],
sum(RealUUAnuladas) as RealUUAnuladas,
sum(RealVtaMNNeto) as RealVtaMNNeto,
sum(RealVtaMNFaltNeto) as RealVtaMNFaltNeto,
sum(RealDevMNNeto) as RealDevMNNeto,
sum(RealAnulMNNeto) as RealAnulMNNeto
INTO ventas2017
from DWH_ANALITICO.DBO.DWH_FVTAPROEBECAM
where CodPais = 'PE' and AnioCampana = AnioCampanaRef and AnioCampana > 201700 and AnioCampana < 201800
group by PKEbelista, AnioCampana

select * from ventas2017


drop table #listaPk
select distinct PKEbelista into #ListaPk from Ventas2017
--272614 rows


drop table #MuestraDePk
SELECT * into #MuestraDePk FROM #listaPk
WHERE (ABS(CAST((BINARY_CHECKSUM(PKEbelista, NEWID())) as int))% 100) < 10
--27233 rows (10%)

drop table #muestraperu
select a.* into #muestraperu from ventas2017 a
inner join #MuestraDePk b on a.PKEbelista=b.PKEbelista
order by a.PKEbelista, AnioCampana
--217746 rows
select * from #muestraperu

select PKEbelista, AnioCampana, RealVtaMNNeto 
from #muestraperu
WHERE AnioCampana = 201701

select AnioCampana, sum(realVtaMNNeto) as total_ventas, COUNT(realvtaMNnETO) as total_pedidos
into #pdp
from #muestraperu
group by AnioCampana
order by AnioCampana

drop table pdp
select *, total_ventas/total_pedidos as p$p
into pdp
from #pdp

select * from pdp
--podria ser que empiezar a disminuir su venta cuando entran nuevas consultoras cerca a ella

