using DashBoardTrains.Models.MockUp_Models;
using Microsoft.AspNetCore.Mvc;

namespace DashBoardTrains.Services
{
    public static class EditFormModel
    {




        public static Stack<string> GenEditFormTable<T>(T scelta, string nomeobj) where T : class
        {
            Stack<string> _htmltable = new Stack<string>();

            var props = scelta.GetType().GetProperties();

            foreach (var prop in props)
            {
                var propType = prop.PropertyType;
                switch (propType)
                {
                    case var a when propType == typeof(string):
                        var value = prop.Name;
                        _htmltable.Push($@" <div class=""col-md-6"">
                            <label class=""form-label"">{prop.Name}</label>
                            <InputText @bind-Value=""{nomeobj}.{value}"" class=""form-control"" placeholder=""{prop.Name}"" />
                            </div>");
                        break;
                    case var b when propType == typeof(int) || propType == typeof(double):
                        var numValue = prop.Name;
                        _htmltable.Push($@" <div class=""col-md-6"">
                            <label class=""form-label"">{prop.Name}</label>
                            <InputNumber @bind-Value=""{nomeobj}.{numValue}"" class=""form-control"" placeholder=""{prop.Name}"" />
                            </div>");
                        break;
                    case var c when propType == typeof(bool):
                        var boolValue = prop.GetValue(scelta) != null && (bool)prop.GetValue(prop)!;
                        _htmltable.Push($@" <div class=""col-md-6"">
                            <label class=""form-label"">{prop.Name}</label>
                            <InputCheckbox @bind-Value=""{nomeobj}.{boolValue}"" class=""form-check-input"" />
                            </div>");
                        break;
                    case var d when propType.IsClass:
                        var classValue = prop.GetValue(scelta);
                        var response = GenEditFormTable(classValue!, $"{prop.Name}");
                        foreach (var item in response)
                        {
                            _htmltable.Push(item);
                        }
                        ;
                        break;
                    default:
                        break;
                }
                ;



            }
            return _htmltable;
        }
    }
}
