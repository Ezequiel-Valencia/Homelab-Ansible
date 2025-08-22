import statistics
import datetime 

# Example Input "2025-08-21 18:15:01 - CPU Temperature: +58.0°C"

class TempTime:
    temperatures = []
    times = []

def parse_temperatures(file_path) -> TempTime:
    _temp_time = TempTime()
    with open(file_path, "r") as f:
        for line in f:
            _temp_time.times.append(line.split(" - ")[0])
            line = line.split("+")[1]
            line = line.split(".")[0]
            if line.isdigit():
                temp = float(line)
                _temp_time.temperatures.append(temp)

    return _temp_time

def compute_average(temperatures) -> int:
    if not temperatures:
        return None
    return sum(temperatures) / len(temperatures)

if __name__ == "__main__":
    file_path = "/var/log/cpu_temp.log"  # replace with your filename
    temp_time = parse_temperatures(file_path)
    temps = temp_time.temperatures
    
    if temps:
        avg = compute_average(temps)
        max_temp = max(temps)
        min_temp = min(temps)
        complete_str = f"Today is {datetime.date.today()}\n"
        complete_str += f"Read {len(temps)} temperatures.\n"
        complete_str += f"Average temperature: {avg:.2f}°C\n"
        complete_str += f"Min temperature: {min_temp:.2f}°C at {temp_time.times[temps.index(min_temp)]}\n"
        complete_str += f"Max temperature: {max_temp:.2f}°C at {temp_time.times[temps.index(max_temp)]}\n"
        complete_str += f"Mode temperature: {statistics.mode(temps):.2f}°C\n"
        complete_str += f"Std Dev. temperature: {statistics.stdev(temps):.2f}°C\n"
        complete_str += "-----------------------------\n"
        print(complete_str)
        with open("/var/log/cpu_temp_stats.log", "a") as f:
            f.write(complete_str)
        
    else:
        print("No temperatures found in file.")
