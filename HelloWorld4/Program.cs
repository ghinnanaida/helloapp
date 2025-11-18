var builder = WebApplication.CreateBuilder(args);

builder.Host.UseSystemd();
builder.Services.AddControllers(); 

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
}

app.UseHttpsRedirection();

app.MapGet("/api/hello", () =>
{
    return Results.Ok(new { message = "Hello World this is from port 5010" });
});

app.Urls.Add("http://*:5010");
app.Run();