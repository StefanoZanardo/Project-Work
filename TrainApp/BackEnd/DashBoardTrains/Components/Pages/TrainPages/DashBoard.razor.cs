namespace DashBoardTrains.Components.Pages.TrainPages
{
    public partial class DashBoard
    {

        private bool _isDropdownOpen = true;

        Dictionary<string, bool> Tables = new()
    {
        { "tutte", false },
        { "treni", false },
        { "categorie", false },
        { "vagoni", false },
        { "semafori", false },
        { "binari", false },
        { "segmenti", false },
        { "bivi", false }
    };
        private void ToggleAll(bool checkedValue)
        {
            var keys = Tables.Keys.ToList();

            foreach (var key in keys)
            {
                Tables[key] = checkedValue;
            }
        }
    }


}
