namespace Test
{
    using Microsoft.AspNetCore.Http;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.EntityFrameworkCore.Infrastructure;

    public class EfCoreInterpolatedTest : Controller
    {
        private DbContext _context;

        // GOOD: ExecuteSqlInterpolated properly parameterizes interpolated strings
        public void SafeExecuteInterpolated(string userInput)
        {
            _context.Database.ExecuteSqlInterpolated($"DELETE FROM Users WHERE Name = {userInput}");
        }

        // BAD: ExecuteSqlRaw with string concatenation is vulnerable
        public void UnsafeExecuteRaw(string userInput)
        {
            _context.Database.ExecuteSqlRaw("DELETE FROM Users WHERE Name = '" + userInput + "'");
        }
    }
}

namespace Microsoft.EntityFrameworkCore
{
    public class DbContext
    {
        public DatabaseFacade Database { get; }
    }

    public class DbSet<T> { }
}

namespace Microsoft.EntityFrameworkCore.Infrastructure
{
    public class DatabaseFacade { }

    public static class RelationalDatabaseFacadeExtensions
    {
        public static int ExecuteSqlInterpolated(this DatabaseFacade database, System.FormattableString sql) => 0;
        public static int ExecuteSqlRaw(this DatabaseFacade database, string sql, params object[] parameters) => 0;
    }

    public static class RelationalQueryableExtensions
    {
        public static System.Linq.IQueryable<TEntity> FromSqlInterpolated<TEntity>(this DbSet<TEntity> source, System.FormattableString sql) where TEntity : class => null;
    }
}
