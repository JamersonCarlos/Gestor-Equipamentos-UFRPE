import 'package:flutter/material.dart';

class ProjectorLoanTable extends StatelessWidget {
  const ProjectorLoanTable({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = [
      {
        'name': 'John Michael',
        'email': 'john@creative-tim.com',
        'avatar': 'https://randomuser.me/api/portraits/men/32.jpg',
        'function': 'Manager',
        'subtitle': 'Organization',
        'status': 'ONLINE',
        'statusColor': Color(0xFF2ECC71),
        'date': '23/04/18',
        'id': 'PRJ001',
        'out': '4/16/2024 14:36',
        'in': '4/17/2024 9:00',
      },
      {
        'name': 'Alexa Liras',
        'email': 'alexa@creative-tim.com',
        'avatar': 'https://randomuser.me/api/portraits/women/44.jpg',
        'function': 'Programator',
        'subtitle': 'Developer',
        'status': 'OFFLINE',
        'statusColor': Color(0xFF6C757D),
        'date': '11/01/19',
        'id': 'PRJ002',
        'out': '4/14/2024 00:30',
        'in': '4/14/2024 10:45',
      },
      {
        'name': 'Laurent Perrier',
        'email': 'laurent@creative-tim.com',
        'avatar': 'https://randomuser.me/api/portraits/men/43.jpg',
        'function': 'Executive',
        'subtitle': 'Projects',
        'status': 'ONLINE',
        'statusColor': Color(0xFF2ECC71),
        'date': '19/09/17',
        'id': 'PRJ003',
        'out': '4/14/2024 11:00',
        'in': '4/15/2024 16:30',
      },
      {
        'name': 'Miriam Eric',
        'email': 'miriam@creative-tim.com',
        'avatar': 'https://randomuser.me/api/portraits/women/65.jpg',
        'function': 'Programtor',
        'subtitle': 'Developer',
        'status': 'ONLINE',
        'statusColor': Color(0xFF2ECC71),
        'date': '14/09/20',
        'id': 'PRJ004',
        'out': '4/15/2024 14:35',
        'in': '4/15/2024 16:35',
      },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Authors table',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              child: Row(
                children: const [
                  Expanded(
                    child: Text(
                      'AUTHOR',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'FUNCTION',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: Center(
                      child: Text(
                        'ID',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'CHECK-OUT',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'CHECK-IN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'STATUS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(width: 60),
                ],
              ),
            ),
            const Divider(height: 0),
            ...entries.map(
              (e) => Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
                ),
                child: Row(
                  children: [
                    // Avatar, nome e email
                    Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage(
                              e['avatar'].toString(),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e['name'].toString(),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                e['email'].toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Função e subtítulo
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e['function'].toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            e['subtitle'].toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ID do projetor (centralizado e largura fixa)
                    SizedBox(
                      width: 90,
                      child: Center(
                        child: Text(
                          e['id'].toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    // Check-Out
                    Expanded(
                      child: Text(
                        e['out'].toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    // Check-In
                    Expanded(
                      child: Text(
                        e['in'].toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    // Status badge
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: (e['statusColor'] as Color).withOpacity(
                                0.15,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              e['status'].toString(),
                              style: TextStyle(
                                color: e['statusColor'] as Color,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Botão More
                    SizedBox(
                      width: 60,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('More'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
