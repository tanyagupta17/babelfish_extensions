-- create windows login and user
create login [bbf\ad_sp_helpuser] from windows;
GO

create user [bbf\ad_sp_helpuser];
GO

-- create password based login
create login pass_sp_helpuser with password = '123';
GO

create user pass_sp_helpuser;
GO