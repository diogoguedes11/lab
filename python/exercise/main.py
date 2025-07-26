import csv



def main():
     process_usage = dict()
     with open("./process_cpu_usage.csv",mode='r') as f:
          read = f.readlines()
          for row in read[1:]:
               line = row.split(",")
               if line[0] not in process_usage:
                    process_usage[line[0]] = int(line[2].strip("\n"))
               else:
                    process_usage[line[0]] += int(line[2].strip("\n"))
     sorted_processes = sorted(process_usage.items(), key=lambda item: int(item[1]), reverse=True)
     for process,cpu in sorted_processes[:3]:
          print("========================================")
          print(f"Process: {process} | Total CPU usage: {cpu}")
if __name__ == "__main__":
   main()