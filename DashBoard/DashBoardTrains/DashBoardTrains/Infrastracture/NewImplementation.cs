namespace DashBoardTrains.Infrastracture
{
    public static class NewImplementation
    {

        public static T NewClass<T>() where T : new()
        {
            return new T();
        }
    }
}
