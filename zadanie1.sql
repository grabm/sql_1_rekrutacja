--Zadnie 1
--Dla tabeli Faktur(int, nr klienta, nr faktury) zaproponuj rozwi¹zanie z osobn¹ numeracj¹ faktur
--per klient, czyli dla klienta 1 mamy faktury 1/1, 1/2, 1/3 ,1/4...1/n i dla ka¿dego kolejnego klienta k/n.

create table Faktury
(id int primary key identity(1,1),
nr_klienta int,
nr_faktury varchar(40))

insert into Faktury (nr_klienta, nr_faktury) values
(1, '1/1'),
(1, '1/2'),
(1, '1/3');

create trigger trig_unikalny_nr_faktury 
on faktury
instead of insert
as
begin
	declare @nr_faktury varchar(40), @nowy_nr_faktury varchar(40)
	declare @nr_klienta_dodawany int = (select nr_klienta from inserted)
	declare @licznik int = (select count(*) from Faktury where @nr_klienta_dodawany = nr_klienta)
	declare @id_klienta_dodawany int = (select id from inserted)
	
	if (@licznik > 0)
	begin
		
		declare @index int
		declare @nr_faktury_po_ukosniku int
		select top 1 @nr_faktury = nr_faktury, @index = CHARINDEX('/', nr_faktury) from Faktury where nr_klienta = @nr_klienta_dodawany order by id desc
		select @nr_faktury_po_ukosniku = CAST(LEFT(REVERSE(@nr_faktury), @index - 1) as int)
		select @nowy_nr_faktury = cast(@nr_klienta_dodawany as varchar) + '/' + cast((@nr_faktury_po_ukosniku + 1) as varchar)

		print 'dodano nr faktury do istniejacego klienta'
		
	end

	else 
	begin
	set @nowy_nr_faktury = cast(@nr_klienta_dodawany  as varchar)+ '/1'

	print 'dodano nowy nr faktury'
	end

	insert into faktury (nr_faktury, nr_klienta) values (@nowy_nr_faktury, @nr_klienta_dodawany)

end;		